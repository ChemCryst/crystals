// Helper functions that do things that Fortran can't do so portably.



#ifdef CRY_FORTINTEL
// Not this one.
#elif CRY_OSWIN32
// but all the other Win32 compilers.
// Make a directory - Windows version, non Intel compilers (e.g. gcc/gfortran).
    void cry_mkdir(const char *dir) {
        _mkdir(dir);
    }
#endif
