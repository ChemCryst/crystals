import os
import sys
import json
import subprocess
import threading 
from shutil import copy, move
import argparse


def deletefiles ( filelist ):

    for f in filelist:
        try:
            copy(f, f+'.prev')
            os.remove(f)
        except FileNotFoundError:
            pass


def write_aspher ( folder, info ):
    with open(folder + os.sep + 'aspher.json', 'w') as file:  
        file.write(json.dumps(disc2tsc_info, sort_keys=True, indent=4))


#def _find_discamb():
def _get_crystals_pref( cr_key ):
    import winreg as reg
    reg_path = r"Software\Chem Cryst\Crystals"

    print ("Checking " + reg_path) 
    for install_type in reg.HKEY_CURRENT_USER, reg.HKEY_LOCAL_MACHINE:
        try:
            reg_key = reg.OpenKey(install_type, reg_path, 0, reg.KEY_READ)
            print ("Querying " + cr_key)
            _path, _type = reg.QueryValueEx(reg_key, cr_key)
            reg_key.Close()
            _path = _path.strip()              # CRYSTALS may add spaces before / after strings
            print ("Found " + _path)
            if not os.path.exists(_path):   
                print ("Path not found")
                continue
        except WindowsError:
            print ("WindowsError")
            _path = None
        else:
            break

    return _path 
    
    
atomic_numbers = {
    'H' : 1,
    'HE':  2,
    'LI':  3,
    'BE': 4,
    'B' : 5,
    'C' : 6,
    'N' : 7,
    'O' : 8,
    'F' : 9,
    'NE': 10,
    'NA': 11,
    'MG': 12,
    'AL': 13,
    'SI': 14,
    'P' : 15,
    'S' : 16,
    'CL': 17,
    'AR': 18,
    'K' : 19,
    'CA': 20,
    'SC': 21,
    'TI': 22,
    'V' : 23,
    'CR': 24,
    'MN': 25,
    'FE': 26,
    'CO': 27,
    'NI': 28,
    'CU': 29,
    'ZN': 30,
    'GA': 31,
    'GE': 32,
    'AS': 33,
    'SE': 34,
    'BR': 35,
    'KR': 36,
    'RB': 37,
    'SR': 38,
    'Y' : 39,
    'ZR': 40,
    'NB': 41,
    'MO': 42,
    'TC': 43,
    'RU': 44,
    'RH': 45,
    'PD': 46,
    'AG': 47,
    'CD': 48,
    'IN': 49,
    'SN': 50,
    'SB': 51,
    'TE': 52,
    'I' : 53,
    'XE': 54,
    'CS': 55,
    'BA': 56,
    'LA': 57,
    'CE': 58,
    'PR': 59,
    'ND': 60,
    'PM': 61,
    'SM': 62,
    'EU': 63,
    'GD': 64,
    'TB': 65,
    'DY': 66,
    'HO': 67,
    'ER': 68,
    'TM': 69,
    'YB': 70,
    'LU': 71,
    'HF': 72,
    'TA': 73,
    'W' : 74,
    'RE': 75,
    'OS': 76,
    'IR': 77,
    'PT': 78,
    'AU': 79,
    'HG': 80,
    'TL': 81,
    'PB': 82,
    'BI': 83,
    'PO': 84,
    'AT': 85,
    'RN': 86,
    'FR': 87,
    'RA': 88,
    'AC': 89,
    'TH': 90,
    'PA': 91,
    'U' : 92,
    'NP': 93,
    'PU': 94,
    'AM': 95,
    'CM': 96,
    'BK': 97,
    'CF': 98,
    'ES': 99,
    'FM': 100,
    'MD': 101,
    'NO': 102,
    'LR': 103,
    'RF': 104,
    'DB': 105,
    'SG': 106,
    'BH': 107,
    'HS': 108,
    'MT': 109,
    'DS': 110, 
    'RG': 111, 
    'CN': 112, 
    'NH': 113,
    'FL': 114,
    'MC': 115,
    'LV': 116,
    'TS': 117,
    'OG': 118
}

def get_crystals_atoms():

    import re

# Output data from CRYSTALS    
    crystals.run(["#RELEASE PUNCH tmp/crystals.l5", "#PUNCH 5", "END"])
    crystals.run(["#RELEASE PUNCH logs/bfile.pch"] )

# Read it into a list of dicts
    atomlist = []
    
    with open('tmp/crystals.l5') as file:  
        
        atom = {}
        aline = 0

        for line in file: 
        
#            print (line)
        
            if len(line) == 0: continue
            if line[0] == '#': continue
            if line[0] == ' ': continue
            if line[0] == '&': continue
            if line[0] == '\\': continue
            strs = re.split(r"[\s,=]\s*", line.strip())
            if len(strs) == 0: continue

#            print( len(strs), strs )

            if aline == 0:
                if strs[0] == 'ATOM':
                    #print (strs[0] + strs[1])
                    atom['type'] = strs[1]
                    atom['serial'] = int(round(float(strs[2])))
                    atom['occ'] = strs[3]
                    atom['flag'] = strs[4]
                    atom['x'] = strs[5]
                    atom['y'] = strs[6]
                    atom['z'] = strs[7]
                    aline = 1
                    continue

            elif aline == 1:
                if strs[0] == 'CON' and strs[1] == 'U[11]' and len(strs) == 8:
                    atom['U11'] = strs[2]
                    atom['U22'] = strs[3]
                    atom['U33'] = strs[4]
                    atom['U23'] = strs[5]
                    atom['U13'] = strs[6]
                    atom['U12'] = strs[7]
                    aline = 2
                    continue
                else:
                    raise Exception("Error 002 reading crystals.l5")
                
            elif aline == 2:
                if strs[0] == 'CON' and strs[1] == 'SPARE' and len(strs) ==7:
                    atom['spare'] = strs[2]
                    atom['part'] = strs[3]
                    atom['ref'] = strs[4]
                    atom['residue'] = int(strs[5])
                    atom['new'] = int(strs[6])
                    atomlist.append(atom)
                    atom = {}
                    aline = 0
                    continue
                else:
                    raise Exception("Error 003 reading crystals.l5")
            
    return atomlist



########################
## Code starts here


# Get command line options

parser = argparse.ArgumentParser(description='Run discamb')
parser.add_argument('--taam', action='store_true', default=False )
parser.add_argument('--basis', choices=['cc-pVDZ','cc-pVQZ','cc-pVTZ','Def2-SVP','Def2-TZVP', 'Def2-TZVPP','jorge-DZP', 'jorge-TZP', 'DKH-def2-SVP'], default='cc-pVDZ')
parser.add_argument('--method', choices=['B3LYP','BLYP','CCSD','HF','M06','MP2'], default='B3LYP')
parser.add_argument('--model', choices=['HAR','TAAM'], default='HAR')
parser.add_argument('--ncores', type=int)
parser.add_argument('--memory', type=ascii)


try:
    args = parser.parse_args()
except SystemExit:               # Can't be passing this exception in an embedded python
    raise Exception("Parse argument error")   # Send a general exception instead
    
print(args)


# "molden2aim folder": "c:\\programy\\Molden2AIM"
moldenfolder = _get_crystals_pref('MOLDENFOLDER')   #NB could be None (if not installed).


argdict = vars(args)

# Check arguments:
# - basis
# - qm method
# - qm program (ORCA)
# - model
# - ncores
# - memory
# - multipole thresholds
# Get resources (if not set above)
# - ncores
# - memory



if ( args.taam ):
    print("Using TAAM model")
else:

    disc2tsc_info = {    'basis set':   argdict['basis'], 
                         'model':       argdict['model'], 
                        'qm method':   argdict['method'], 
                         'n cores':     argdict['ncores'],
                         'memory':      argdict['memory'],
                         'qm program':  'Orca',
                         'qm structure': 'qm_sys',
                         'multipoles': { 'l max': 2, 'threshold': 15.0 }
                    }

    if moldenfolder is not None:
        disc2tsc_info['molden2aim folder'] = moldenfolder


    if argdict['ncores'] is None:
        # Get number of available cores, n_cores.
        try:
            import multiprocessing
            disc2tsc_info['n cores'] = multiprocessing.cpu_count()
            print( f"There are {disc2tsc_info['n cores']} core(s) available" )
        except:
            disc2tsc_info['n cores'] = 4
            print( f"Cannot determine number of cores, defaulting to 4 (see discamb.py line {sys._getframe().f_back.f_lineno})" )

    if argdict['memory'] is None:
        disc2tsc_info['memory'] = '1GB'


    #
    # Check path to discamb.
    # Double check settings.json paths set (warnings)
    # Write quick res
    #
    # {
    #    "basis set": "cc-pVDZ",
    #    "memory": "1GB",
    #    "model": "HAR",
    #    "multipoles": {
    #        "l max": 2,
    #        "threshold": 15.0
    #    },
    #    "n cores": 4,
    #    "qm method": "B3LYP",
    #    "qm program": "Orca",
    #    "qm structure": "qm_sys"
    #}



# Get available memory
# (Requires psutil library to do this - let's leave default for now.)


# Get discamb path

#discambexe = _find_discamb()
discambexe = _get_crystals_pref('DISCAMB2TSCEXE')
if discambexe is None:
    raise Exception('The path to discamb2tsc must be set in CRYSTALS Tools / Preferences')



# Check existence
if not os.path.exists(discambexe):
    raise Exception('An incorrect path to discamb2tsc is set in CRYSTALS Tools / Preferences')

#Extract path from exe location
discamb_path = os.path.dirname(os.path.dirname(discambexe))

# TODO: Check settings.json for correct ORCA path
orca_path = None
try:
    with open(discamb_path + os.sep + 'settings' + os.sep + 'settings.json') as file:  
        settings = json.load(file)
except:
    raise Exception("Error opening discamb2tsc/settings/settings.json")

orca_path = settings['orca folder']
if not os.path.exists(orca_path):
    raise Exception("Orca path set incorrectly in discamb2tsc/settings/settings.json")

# Make a work folder
work_folder = 'discamb2tsc'
try:
    os.mkdir(work_folder)
except FileExistsError:
    pass                #overwrite previous jobs


deletefiles( [ work_folder + os.sep + 'aspher.json'])   #remove previous job control


# Output res and hkl
try:
    import crystals            #Defined in the embedded environment in CRYSTALS
    crystals.run(["#FORE SHELX HARD", "END"])
    crystals.run(["#RELE PUNCH crystals.hkl", 
                  "#PUNCH 6 F", "END"] )
    crystals.run(["#RELEASE PUNCH logs/bfile.pch"] )
except Exception as e:
    print(sys.exc_info())
    raise Exception("discamb.py must be run in CRYSTALS")

copy('crystals.hkl', work_folder )
copy('shelxs.ins', work_folder + os.sep + 'crystals.ins' )

atoms = get_crystals_atoms()


# If basis set has relativistic alternative for Z>36
#"basis set per element": "H,cc-pVTZ C,N,cc-pVDZ O,6-31G",

#       print(f"{atom['type']} {atom['serial']} {atom['x']} {atom['y']} {atom['z']} {atom['residue']}")

if not args.taam:
    if disc2tsc_info['basis set'] in ['DKH-def2-SVP']:
        too_heavy = set()
        for atom in atoms:
            z = atomic_numbers[atom['type'].upper()]
            if z > 36 and z not in too_heavy:
                if ( len(too_heavy) == 0 ):
                    disc2tsc_info['basis set per element'] = "" # initialize this key
                too_heavy.add(z)
                elname = atom['type']
                if len(elname) > 1:
                    elname = elname[0] + elname[1].lower()
                disc2tsc_info['basis set per element'] = disc2tsc_info['basis set per element'] + elname + ","
        if len(too_heavy) > 0:
            disc2tsc_info['basis set per element'] = disc2tsc_info['basis set per element'] + "SARC-DKH-TZVP"


    write_aspher(work_folder, disc2tsc_info)

 
residue_vals = set( [ r['residue'] for r in atoms ] )   

print (f" -- There are {len(residue_vals)} residue(s): ")

all_residues = dict()

net_charge = 0

for res in residue_vals:
#    print (res)
    residue = dict()  # store properties for each residue in here.
    all_residues[res] = residue # and store each of these residues in here.

    #sum charge ('new') for each residue
    charge = sum( [ r['new'] for r in atoms if r['residue'] == res ] )
    net_charge += charge
    residue['charge'] = charge
    print(f"\n -- Charge on res {res} is {charge}")
    
    #sum n_electrons for each residue
    nelec = sum( [ atomic_numbers[r['type'].upper()] for r in atoms if r['residue'] == res ] )
    residue['nelec'] = nelec - charge
    residue['mult'] = (nelec - charge)%2 + 1
    print(f" -- N electrons on res {res} is {nelec - charge}, spin mult is {residue['mult']}")
    
    #get spin mult
if ( net_charge != 0 ):
    print ("{E Warning net charge on all molecules is not zero")

print (f"Net charge on all molecules is {net_charge}")

# Make a set of separate molecules using the 'residue' number.

with open(work_folder + os.sep + 'qm_sys', 'w') as file:  
    for resid,res in all_residues.items():
        file.write(f"System r{resid} {res['charge']} {res['mult']}\n")
        for atom in atoms:
            if atom['residue'] != resid: continue
            file.write(f"{atom['type']}{atom['serial']}\n")
        
#        atom = [ r for r in atoms if r['residue'] == resid ][0]
#        file.write(f"$connect {atom['type']}{atom['serial']}\n")




deletefiles( [ 'default.tsc',
               work_folder + os.sep + 'discamb_error.log',
               work_folder + os.sep + 'discamb2tsc.log',
               work_folder + os.sep + 'task_1.log'] )

#Run discamb


print ("Launching discamb2tsc. This may take several minutes to hours.")

#subprocess.run( "echo %DISCAMB_PATH% > afile", 
#                shell=True, stdout = subprocess.PIPE, stderr = subprocess.STDOUT,
#                cwd = work_folder,
#                env = dict(os.environ, DISCAMB_PATH=discamb_path)
#              )


#subprocess.run( [ discambexe, "crystals.ins", "crystals.hkl" ], 
#                stdout = subprocess.PIPE, stderr = subprocess.STDOUT,
#                cwd = work_folder, shell=True,
#                env = dict(os.environ, DISCAMB_PATH=discamb_path)
#              )

#subprocess.run( [ discambexe, "crystals.ins", "crystals.hkl" ], 
#                stdout = sys.stdout, stderr = sys.stderr,
#                cwd = work_folder, 
                #shell=True,
#                env = dict(os.environ, DISCAMB_PATH=discamb_path)
#              )



def output_reader(proc):
    for line in iter(proc.stdout.readline, b''):
        print('{{0,1 {0}'.format(line.decode('utf-8')), end='')



# Check for wrong mpiexec
#shutil.which(cmd, mode=os.F_OK | os.X_OK, path=None)


si = None
if os.name == 'nt':
    si = subprocess.STARTUPINFO()
    si.dwFlags |= subprocess.STARTF_USESHOWWINDOW

proc = subprocess.Popen([ discambexe, "crystals.ins", "crystals.hkl" ], 
                cwd = work_folder, 
                env = dict(os.environ, DISCAMB_PATH=discamb_path, PYTHONBUFFERED="1"),
                startupinfo = si,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT)

t = threading.Thread(target=output_reader, args=(proc,))
t.start()
print("^^CO SET _MAINPROGRESS PULSE\n")
t.join()

print("\n^^CO SET _MAINPROGRESS TEXT 'Ready'\n")

print ("Done. Copying results tsc...")

copy( work_folder + os.sep + 'crystals.tsc', 'default.tsc' )

print ("\nAll done. \n\n\n")


