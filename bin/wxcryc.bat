
set CL=/GX /D"WIN32" /D"_WINDOWS" /D"__WINMSW__" /D"__WXMSW__" /c
CL /Fo%1.obj /GB /MD  /W3 /O1 /Ob2 /D"NDEBUG"  %1.cpp 
CL /Fo%1d.obj /Gm /MDd /W3 /Zi /Od  /D"_DEBUG" %1.cpp 

