import os
import sys
import json

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

disc2tsc_info = {    'basis set':   'cc-pVDZ', 
                     'model':       'HAR', 
                     'qm method':   'B3LYP', 
                     'n cores':     12,
                     'memory':      '1GB',
                     'qm program':  'Orca',
                     'multipoles': { 'l max': 2, 'threshold': 15.0 }
                }


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


def write_aspher ( folder, info ):
    with open(folder + os.sep + 'aspher.json', 'w') as file:  
        file.write(json.dumps(disc2tsc_info, sort_keys=True, indent=4))


def _find_discamb():
    import winreg as reg
    reg_path = r"Software\Chem Cryst\Crystals"

    print ("Checking " + reg_path) 
    for install_type in reg.HKEY_CURRENT_USER, reg.HKEY_LOCAL_MACHINE:
        try:
            reg_key = reg.OpenKey(install_type, reg_path, 0, reg.KEY_READ)
            print ("Querying ")
            _path, _type = reg.QueryValueEx(reg_key, 'DISCAMB2TSCEXE')
            reg_key.Close()
            _path = _path.strip()              # CRYSTALS may add spaces before / after strings
            print ("Found " + _path)
            if not os.path.isfile(_path):   
                print ("Path not found")
                continue
        except WindowsError:
            print ("WindowsError")
            _path = None
        else:
            break

    return _path 


# Get number of available cores, n_cores.
try:
    import multiprocessing
    disc2tsc_info['n cores'] = multiprocessing.cpu_count()
    print( f"There are {disc2tsc_info['n cores']} core(s) available" )
except:
    print( f"Cannot determine number of cores, defaulting to 4 (see discamb.py line {sys._getframe().f_back.f_lineno})" )


# Get available memory
# (Requires psutil library to do this - let's leave default for now.)


# Get discamb path

discambexe = _find_discamb()
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

write_aspher(work_folder, disc2tsc_info)

# Output res and hkl
try:
    import crystals
    crystals.run(["#FORE SHELX HARD", "END"])
    crystals.run(["#RELE PUNCH crystals.hkl", 
                  "#PUNCH 6 F", 
                  "END", 
                  "#RELEASE PUNCH logs/bfile.pch"] )
except Exception as e:
    print(sys.exc_info())
    raise Exception("discamb.py must be run in CRYSTALS")

from shutil import copy
copy('crystals.hkl', work_folder )
copy('shelxs.ins', work_folder + os.sep + 'crystals.ins' )



#Run discamb

import subprocess

print ("Launching discamb2tsc...")

subprocess.run( [ discambexe, "crystals.ins", "crystals.hkl" ], 
                capture_output=True, 
                cwd = work_folder,
                env = dict(os.environ, DISCAMB_PATH=discamb_path)
              )




