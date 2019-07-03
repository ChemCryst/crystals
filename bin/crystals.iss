
#if "INW" == GetEnv('COMPCODE')
  #define crysOS 'win-int'
#elif "GID" == GetEnv('COMPCODE')
  #define crysOS 'win-dvf'
#else
  #define crysOS 'unknown'
#endif

#if "TRUE" == GetEnv('CROPENMP')
  #define crysOS 'win-int32-openmp'
#endif

#if "TRUE" == GetEnv('CR64BIT')
  #define crysOS 'win-int64-openmp'
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
AppVerName=CRYSTALS 15.{#crysSVN} ({#crysVDATE})
AppVersion=15.0.{#crysSVN}
OutputBaseFilename=crystals-{#crysOS}-15.{#crysSVN}-{#crysDATE}-setup


PrivilegesRequired=none

AppName=CRYSTALS
OutputDir=..\installer
AppCopyright=Copyright (c) University of Oxford, 1 July 2019. All rights reserved.
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
DefaultDirName={autopf64}\crystals
DefaultGroupName=Crystals
;These files display during the installation:
DiskSpanning=0
WizardImageFile=..\bin\instimage.bmp
LicenseFile=..\bin\licence.txt
InfoAfterFile=..\bin\postinst.txt

[Dirs]
Name: {app}\Manual
Name: {app}\Script
Name: {autoappdata}\crystals\demo; Permissions: users-modify
Name: {app}\mce
Name: {app}\MCE\mce_manual_soubory

[Files]
Source: ..\build\*.*; DestDir: {app}\; Excludes: "make*,buildfile.bat,code.bat"; Flags: ignoreversion;
Source: ..\build\script\*.*; DestDir: {app}\script\;
Source: ..\build\mce\*.*; DestDir: {app}\mce\;  Flags: ignoreversion recursesubdirs;
Source: ..\build\manual\*.*; DestDir: {app}\manual\; Flags: ignoreversion recursesubdirs;
Source: ..\build\demo\*; DestDir: {autoappdata}\crystals\demo\; Flags: recursesubdirs; Excludes: "*.doc"; Permissions: users-modify;

[Icons]
Name: "{userdesktop}\Crystals";                 Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0; Check: Not IsAdminInstallMode;
Name: "{userdesktop}\Crystals Getting Started"; Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"; Check: Not IsAdminInstallMode;
Name: "{commondesktop}\Crystals";                 Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0; Check: IsAdminInstallMode;
Name: "{commondesktop}\Crystals Getting Started"; Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"; Check: IsAdminInstallMode;

Name: "{group}\Crystals";                       Filename: "{app}\crysload.exe";        WorkingDir: "{app}"; IconFilename: "{app}\crystals.exe"; IconIndex: 0;
Name: "{group}\HTML help";                      Filename: "{app}\Manual\Crystcon.htm"; WorkingDir: "{app}"
Name: "{group}\Getting Started";                Filename: "{app}\manual\readme.html";  WorkingDir: "{app}"
Name: "{group}\Uninstall CRYSTALS";             Filename: "{uninstallexe}";
Name: "{group}\Example structures";             Filename: "{autoappdata}\demo"

[INI]
;
; This ini file is kept for backwards compatibilty. WinGX uses it. (Can't be written in non-admin mode install)
;

Filename: wincrys.ini; Section: Setup; Key: Location; String: "{app}"; Flags: uninsdeleteentry; Check: IsAdminInstallMode;
Filename: wincrys.ini; Section: Setup; Key: Crysdir; String: "{autoappdata}\crystals\,{app}\"; Flags: uninsdeleteentry; Check: IsAdminInstallMode;
Filename: wincrys.ini; Section: Latest; Key: Strdir; String: "{autoappdata}\crystals\demo\demo"; Flags: uninsdeleteentry; Check: IsAdminInstallMode;

[Run]
; Skip this - we will copy DLLs for now (less error prone).
;#if "INW" == GetEnv('COMPCODE')
;Filename: "msiexec.exe"; Parameters: "/i ""{app}\w_fcompxe_redist_ia32_2011.3.175.msi"" /qn"; StatusMsg: "Installing Intel DLL Libraries";
;#endif


;NB. CRYSDIR is no longer stored in the registry, so don't set it - it will mess up left-over old versions of CRYSTALS (which we can't uninstall without admin privileges.)
;    Location is no longer used by crysload to find the .exe - it just assumes it will be alongside.

[Registry]
Root: HKA32; Subkey: "Software\Chem Cryst"; Flags: uninsdeletekeyifempty
Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; Flags: uninsdeletekey
;Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Location"; ValueData: "{app}"

Root: HKA64; Subkey: "Software\Chem Cryst"; Flags: uninsdeletekeyifempty; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; Flags: uninsdeletekey; Check: IsWin64
;Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Location"; ValueData: "{app}"; Check: IsWin64


Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Strdir"; ValueData: "{autoappdata}\crystals\demo\demo"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontHeight"; ValueData: "8"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontWidth"; ValueData: "0"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontFace"; ValueData: "Lucida Console"; Flags: createvalueifdoesntexist
Root: HKA32; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "PLATONDIR"; ValueData: "{app}\platon.exe"; Flags: createvalueifdoesntexist

Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "Strdir"; ValueData: "{autoappdata}\crystals\demo\demo"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontHeight"; ValueData: "8"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontWidth"; ValueData: "0"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "FontFace"; ValueData: "Lucida Console"; Flags: createvalueifdoesntexist; Check: IsWin64
Root: HKA64; Subkey: "Software\Chem Cryst\Crystals"; ValueType: string; ValueName: "PLATONDIR"; ValueData: "{app}\platon.exe"; Flags: createvalueifdoesntexist; Check: IsWin64


Root: HKA32; SubKey: "Software\Classes\.dsc"; ValueType: STRING; ValueData: CrystalsFile; Flags: uninsdeletevalue
Root: HKA32; SubKey: "Software\Classes\CrystalsFile"; ValueType: STRING; ValueData: Crystals Data File; Flags: uninsdeletevalue
Root: HKA32; SubKey: "Software\Classes\CrystalsFile\Shell\Open\Command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1"""; Flags: uninsdeletevalue
Root: HKA32; SubKey: "Software\Classes\CrystalsFile\DefaultIcon"; ValueType: STRING; ValueData: {app}\crystals.exe,1; Flags: uninsdeletevalue

Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1\crfilev2.dsc""";  Flags: uninsdeletekey; OnlyBelowVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; MinVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey; Check: IsWin64

Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals"; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey
Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1\crfilev2.dsc""";  Flags: uninsdeletekey; OnlyBelowVersion: 6.0
Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; MinVersion: 6.0
Root: HKA32; SubKey: "Software\Classes\Directory\shell\crystals"; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey

Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%1\crfilev2.dsc""";  Flags: uninsdeletekey; OnlyBelowVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals\command"; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; MinVersion: 6.0; Check: IsWin64
Root: HKA64; SubKey: "Software\Classes\Directory\shell\crystals"; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey; Check: IsWin64


Root: HKA32; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey
Root: HKA32; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey
Root: HKA32; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey

Root: HKA64; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueType: STRING; ValueData: Open Crystals Here;  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals\command; ValueType: STRING; ValueData: """{app}\crystals.exe"" ""%v\crfilev2.dsc""";  Flags: uninsdeletekey; Check: IsWin64
Root: HKA64; SubKey: SOFTWARE\Classes\Directory\Background\shell\crystals; ValueName: Icon; ValueType: STRING; ValueData: "{app}\crystals.exe,0";  Flags: uninsdeletekey; Check: IsWin64
