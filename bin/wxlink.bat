call wxcryc.bat %1
set LINK= /WARN:3 /NODEFAULTLIB /SUBSYSTEM:WINDOWS
LINK /OUT:%1.exe /OPT:REF %1.obj  wx.lib  dformd.lib dfport.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib shell32.lib oldnames.lib comctl32.lib ole32.lib uuid.lib advapi32.lib wsock32.lib glu32.lib opengl32.lib msvcrt.lib  msvcirt.lib
LINK /OUT:%1d.exe  /DEBUG %1d.obj wxd.lib dformd.lib dfport.lib kernel32.lib user32.lib gdi32.lib comdlg32.lib shell32.lib oldnames.lib comctl32.lib ole32.lib uuid.lib advapi32.lib wsock32.lib glu32.lib opengl32.lib msvcrtd.lib msvcirtd.lib msvcprtd.lib rpcrt4.lib 


