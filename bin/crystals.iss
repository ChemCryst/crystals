
#if "INW" == GetEnv('COMPCODE')
  #define crysOS 'win-int'
#elif "GID" == GetEnv('COMPCODE')
  #define crysOS 'win-dvf'
#else
  #define crysOS 'unknown'
#endif

#if "TRUE" == GetEnv('CROPENMP')
  #define crysOS 'win-int-openmp'
#endif


#if Len(GetEnv('CRYSVNVER')) > 0 
  #define crysSVN GetEnv('CRYSVNVER')
#else
  #define crysSVN 'xxxx'
#endif

#define crysDATE GetDateTimeString('mmmyy','','')
#define crysVDATE GetDateTimeString('mmm yyyy','','')

[Setup]
;
;Adjust the program names and version here as appropriate:
;
AppVerName=CRYSTALS 14.{#crysSVN} ({#crysVDATE})
AppVersion=14.{#crysSVN}
;OutputBaseFilename=crystals-a1452-Sep12-setup
OutputBaseFilename=crystals-{#crysOS}-14.{#crysSVN}-{#crysDATE}-setup


AppName=CRYSTALS
OutputDir=..\installer
AppCopyright=Copyright (c) University of Oxford, 1 August 2014. All rights reserved.
AppPublisher=Chemical Crystallography Laboratory, University of Oxford
AppPublisherURL=http://www.xtl.ox.ac.uk/
BackSolid=0
ChangesAssociations=Yes

SolidCompression=yes
Compression=bzip

DisableDirPage=0
DisableStartupPrompt=yes
CreateAppDir=1
DisableProgramGroupPage=yes
Uninstallable=1
AllowNoIcons=0
DefaultDirName={sd}\Wincrys
DefaultGroupName=Crystals
;These files display during the installation:
DiskSpanning=0
WizardImageFile=..\bin\instimage.bmp
LicenseFile=..\bin\licence.txt
InfoAfterFile=..\bin\postinst.txt

[Dirs]
Name: {app}\Manual
Name: {app}\Manual\analyse
Name: {app}\Script
Name: {app}\user
Name: {app}\user\Script
Name: {app}\demo
Name: {app}\mce
Name: {app}\MCE\mce_manual_soubory

[Files]                                                     
Source: ..\build\*.*; DestDir: {app}\; Excludes: "make*,buildfile.bat,code.bat";
Source: ..\build\script\*.*; DestDir: {app}\script\;
Source: ..\build\mce\*.*; DestDir: {app}\mce\;  Flags: ignoreversion;            
Source: ..\build\mce\mce_manual_soubory\*.*; DestDir: {app}\mce\mce_manual_soubory\;
Source: ..\build\manual\*.*; DestDir: {app}\manual\;
Source: ..\build\manual\analyse\*.*; DestDir: {app}\manual\analyse\;
Source: ..\build\demo\*; DestDir: {app}\demo\; Flags: recursesubdirs; Excludes: "*.doc";

[Icons]
Name: "{userdesktop}\Crystals";                 Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0
Name: "{userdesktop}\Crystals Getting Started"; Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"
Name: "{group}\Crystals";                       Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0
Name: "{group}\HTML help";                      Filename: "{app}\Manual\Crystcon.htm"; WorkingDir: "{app}"
Name: "{group}\Getting Started";                Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"

[INI]
;
; This ini file is kept for backwards compatibilty. WinGX uses it.
;
Filename: wincrys.ini; Section: Setup; Key: Location; String: "{app}"; Flags: uninsdeleteentry
Filename: wincrys.ini; Section: Setup; Key: Crysdir; String: "{app}\user\,{app}\"; Flags: uninsdeleteentry
Filename: wincrys.ini; Section: Latest; Key: Strdir; String: "{app}\demo\demo"; Flags: uninsdeleteentry

[Run]
; Skip this - we will copy DLLs for now (less error prone).
;#if "INW" == GetEnv('COMPCODE')
;Filename: "msiexec.exe"; Parameters: "/i ""{app}\w_fcompxe_redist_ia32_2011.3.175.msi"" /qn"; StatusMsg: "Installing Intel DLL Libraries";
;#endif


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
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontHeight"; ValueData: "8"; Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontWidth"; ValueData: "0"; Flags: createvalueifdoesntexist
Root: HKCU; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontFace"; ValueData: "Lucida Console"; Flags: createvalueifdoesntexist
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
Root: HKCR; SubKey: Directory\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey
Root: HKCR; SubKey: Directory\shell\crystals; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey

Root: HKLM; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey
Root: HKLM; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey
Root: HKLM; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey

