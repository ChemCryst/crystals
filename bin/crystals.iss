[Dirs]
Name: {app}\Example
Name: {app}\Nket
Name: {app}\Manual
Name: {app}\Script
Name: {app}\user
Name: {app}\user\Script
Name: {app}\demo\demo
Name: {app}\demo\cyclo
Name: {app}\demo\ylid
Name: {app}\demo\disorder
Name: {app}\demo\kpenv
Name: {app}\demo\peach
Name: {app}\demo\editor
Name: {app}\demo\twin
Name: {app}\demo\quick
Name: {app}\demo\keen
Name: {app}\demo\mogul

[Messages]
SelectDirLabel=Select a folder for [name] to be installed in.

[Setup]

MinVersion=4.0,4.0
;
;Adjust the program names and version here as appropriate:
;
AppVerName=CRYSTALS 12.40 (July 2004)
AppVersion=12.40
AppName=CRYSTALS
AppCopyright=Copyright ¸ Chemical Crystallography Laboratory, Oxford
AppPublisher=Chemical Crystallography Laboratory, University of Oxford
AppPublisherURL=http://www.xtl.ox.ac.uk/
Bits=32
BackSolid=0
ChangesAssociations=Yes
Compression=bzip
DisableDirExistsWarning=0
DisableDirPage=0
DisableStartupPrompt=yes
CreateAppDir=1
DisableProgramGroupPage=yes
OverwriteUninstRegEntries=1
Uninstallable=1
AllowNoIcons=0
AlwaysRestart=0
DefaultDirName={sd}\Wincrys
DefaultGroupName=Crystals
;These files display during the installation:
MessagesFile=compiler:default.isl
DiskSpanning=0
WizardImageFile=..\bin\instimage.bmp
LicenseFile=..\bin\licence.txt
InfoAfterFile=..\bin\postinst.txt

[Files]                                                     
Source: ..\build\*.*; DestDir: {app}\;                      
Source: ..\build\script\*.*; DestDir: {app}\script\;        
Source: ..\build\mce\*.*; DestDir: {app}\mce\;              
Source: ..\build\nket\*.*; DestDir: {app}\nket\;            
Source: ..\build\example\*.*; DestDir: {app}\example\;      
Source: ..\build\manual\*.*; DestDir: {app}\manual\;        
Source: ..\build\demo\cyclo\*.*; DestDir: {app}\demo\cyclo\;
Source: ..\build\demo\demo\*.*; DestDir: {app}\demo\demo\;  
Source: ..\build\demo\editor\*.*; DestDir: {app}\demo\editor\;
Source: ..\build\demo\keen\*.*; DestDir: {app}\demo\keen\;  
Source: ..\build\demo\peach\*.*; DestDir: {app}\demo\peach\;
Source: ..\build\demo\quick\*.*; DestDir: {app}\demo\quick\;
Source: ..\build\demo\shape\*.*; DestDir: {app}\demo\shape\;
Source: ..\build\demo\shape2\*.*; DestDir: {app}\demo\shape2\;
Source: ..\build\demo\twin\*.*; DestDir: {app}\demo\twin\;
Source: ..\build\demo\twin2\*.*; DestDir: {app}\demo\twin2\;
Source: ..\build\demo\twin3\*.*; DestDir: {app}\demo\twin3\;
Source: ..\build\demo\ylid\*.*; DestDir: {app}\demo\ylid\;
Source: ..\build\demo\disorder\*.*; DestDir: {app}\demo\disorder\;
Source: ..\build\demo\kpenv\*.*; DestDir: {app}\demo\kpenv\;
Source: ..\build\demo\mogul\*.*; DestDir: {app}\demo\mogul\;

[Icons]
Name: {userdesktop}\Crystals; Filename: {app}\crysload.exe; WorkingDir: {app}; IconFilename: {app}\crystals.exe; IconIndex: 0
Name: {userdesktop}\Crystals Getting Started; Filename: {app}\manual\readme.html; WorkingDir: {app}
Name: {group}\Crystals; Filename: {app}\crysload.exe; WorkingDir: {app}; IconFilename: {app}\crystals.exe; IconIndex: 0
Name: {group}\HTML help; Filename: {app}\Manual\Crystcon.htm; WorkingDir: {app}
Name: {group}\Getting Started; Filename: {app}\manual\readme.html; WorkingDir: {app}

[INI]
;
; This ini file is kept for backwards compatibilty. WinGX uses it.
;
Filename: wincrys.ini; Section: Setup; Key: Location; String: "{app}"; Flags: uninsdeleteentry
Filename: wincrys.ini; Section: Setup; Key: Crysdir; String: "{app}\user\,{app}\"; Flags: uninsdeleteentry
Filename: wincrys.ini; Section: Latest; Key: Strdir; String: "{app}\demo\demo"; Flags: uninsdeleteentry

[Registry]
Root: HKLM; Subkey: "Software\Chem Cryst"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "Software\Chem Cryst\Crystals"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Location"; ValueData: "{app}"
Root: HKLM; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Crysdir"; ValueData: "{app}\user\,{app}\"

Root: HKCU; Subkey: "Software\Chem Cryst"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; Flags: uninsdeletekey

Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Location"; ValueData: "{app}"
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Crysdir"; ValueData: "{app}\user\,{app}\"

Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Strdir"; ValueData: "{app}\demo\demo"; Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontHeight"; ValueData: "-9"; Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontWidth"; ValueData: "0"; Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontFace"; ValueData: "Courier New"; Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "PLATONDIR"; ValueData: "{app}\platon.exe"; Flags: createvalueifdoesntexist

Root: HKCR; SubKey: .dsc; ValueType: STRING; ValueData: CrystalsFile; Flags: uninsdeletevalue
Root: HKCR; SubKey: CrystalsFile; ValueType: STRING; ValueData: Crystals Data File; Flags: uninsdeletevalue
Root: HKCR; SubKey: CrystalsFile\Shell; ValueType: NONE; Flags: uninsdeletevalue
Root: HKCR; SubKey: CrystalsFile\Shell\Open; ValueType: NONE; Flags: uninsdeletevalue
Root: HKCR; SubKey: CrystalsFile\Shell\Open\Command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1"""; Flags: uninsdeletevalue
Root: HKCR; SubKey: CrystalsFile\DefaultIcon; ValueType: STRING; ValueData: {app}\crystals.exe,1; Flags: uninsdeletevalue

;These were only to correct v11.99 error, now removed.
;
; Root: HKCR; SubKey: Directory\shell; ValueType: STRING; ValueData: none; MinVersion: 5,5
; Root: HKCR; SubKey: Directory\shell; ValueType: NONE;  OnlyBelowVersion: 5,5; Flags: deletevalue

Root: HKCR; SubKey: Directory\shell\crystals; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey
Root: HKCR; SubKey: Directory\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%L\crfilev2.dsc""";  Flags: uninsdeletekey


[UninstallDelete]
Name: {app}\rc93.bat; Type: files
Name: {app}\oldcrys.bat; Type: files
Name: {app}\sir92.bat; Type: files
Name: {app}\kccdin.bat; Type: files

[InstallDelete]
Name: {app}\writebat.bat; Type: files

[Run]
Filename: command.com; Parameters: "/e:3072 /c writebat.bat {app}\"; WorkingDir: {app}

