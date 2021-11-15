import os

def _find_strdir_win():
    import winreg as reg
    reg_path = r"Software\Chem Cryst\Crystals"

    print ("Checking " + reg_path) 
    for install_type in reg.HKEY_CURRENT_USER, reg.HKEY_LOCAL_MACHINE:
        try:
            reg_key = reg.OpenKey(install_type, reg_path, 0, reg.KEY_READ)
            _path, _type = reg.QueryValueEx(reg_key, 'Strdir')
            reg_key.Close()
            if not os.path.isdir(_path):
                continue
        except WindowsError:
            print ("WindowsError")
            _path = None
        else:
            break

    return _path 
    
    
print ( "Strdir in registry is " +  _find_strdir_win() )

