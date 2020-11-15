
extern "C" {
	

#define PY_SSIZE_T_CLEAN
#include <windows.h>

#include <sys/stat.h>
#include <Python.h>   //Needed for the definitions of PyObject, PyModuleDef, etc.

//#include <object.h>
//#include <methodobject.h>
//#include <moduleobject.h>
//#include <pyarena.h>
//#include <compile.h>
#include <stdlib.h>


// This python module, implemented in C will be used later to redirect text
// output from the interpreter while it is running. Text should end up on the
// screen in CRYSTALS.
// Solution discussed here: https://stackoverflow.com/questions/7935975/asynchronously-redirect-stdout-stdin-from-embedded-python-to-c
// and updates required for Python 3 here:
// https://stackoverflow.com/questions/28305731/compiler-cant-find-py-initmodule-is-it-deprecated-and-if-so-what-should-i

void lineout(const char* string, int);

void lineouts(const char* string) {
	lineout(string,strlen(string));
}

//unsigned long GetModuleFileNameA( void * hModule, char * lpFilename, unsigned long nSize);

// For dynamic loading of python dll, we need to find the address of each function with a call
// to getprocaddress (these are stored in the global FARPROC pointers defined here). And we also
// need to know the function signature - this is a pain, because you have to explicitly (and correctly)
// set out each function here, but it is useful becuase we are not relying on Python.h. 
// If the function signatures change in future python releases, loading the new DLL here might not work.
// Another advantage of a dynamic load is that we can fail gracefully if python.dll is not found and carry
// on without it.

// void Py_InitializeEx ( int )
FARPROC pInitializeExFn;
typedef void (*PINITIALIZEEXFN)( int ) ;

//PyAPI_FUNC(void) Py_SetPythonHome(const wchar_t *);
FARPROC pSetPythonHomeFn;
typedef void (*PSETPYTHONHOME)( const wchar_t *);

FARPROC pImport_AppendInittabFn;
typedef int (*PIMPORT_APPENDINITTAB)( const char *, PyObject *(*func)(void));

//PyAPI_FUNC(int) PyRun_SimpleStringFlags(const char *, PyCompilerFlags *);
FARPROC pRun_SimpleStringFlags;
typedef int (*PRUN_SIMPLESTRINGFLAGS)( const char *, PyCompilerFlags *);

//PyAPI_FUNC(PyObject*) PyUnicode_DecodeFSDefault(const char *s);
FARPROC pUnicode_DecodeFSDefaultFn;
typedef PyObject* (*PUNICODE_DECODEFSDEFAULT)( const char *);

//PyAPI_FUNC(PyObject *) PyImport_Import(PyObject *name);
FARPROC pImport_ImportFn;
typedef PyObject* (*PIMPORT_IMPORT)( PyObject *);
//PyAPI_FUNC(PyObject *) PyImport_ReloadModule(PyObject *name);
FARPROC pImport_ReloadModuleFn;
typedef PyObject* (*PIMPORT_RELOADMODULE)( PyObject *);

//PyAPI_FUNC(void) PyMem_RawFree(void *ptr);
FARPROC pMem_RawFreeFn;
typedef void (*PMEM_RAWFREE)( void *);

//int Py_FinalizeEx()
FARPROC pFinalizeExFn;
typedef int (*PFINALIZEEX)();

// PyAPI_FUNC(wchar_t *) Py_DecodeLocale(const char *arg,size_t *size);
FARPROC pDecodeLocaleFn;
typedef wchar_t* (*PDECODELOCALE)(const char *, size_t *);

// PyAPI_FUNC(PyObject *) PyModule_Create2(struct PyModuleDef*, int apiver);
#define PYTHON_ABI_VERSION 3
FARPROC pModule_Create2Fn;
typedef PyObject* (*PMODULECREATE2)(PyModuleDef *, int);

// int (*py3_PyArg_ParseTuple)(PyObject *, char *, ...);
FARPROC pArg_ParseTupleFn;
typedef int (*PARGPARSETUPLE)(PyObject *, char *, ...);

// (PyObject *) Py_BuildValue(const char *, ...);
FARPROC pBuildValueFn;
typedef PyObject* (*PBUILDVALUE)(const char *, ...);

//int PyRun_SimpleFileExFlags(FILE *fp, const char *filename, int closeit, PyCompilerFlags *flags)
FARPROC pRun_SimpleFileExFlagsFn;
typedef int (*PRUNSIMPLEFILEEXFLAGS)(FILE *fp, const char *filename, int closeit, PyCompilerFlags *flags);

//FILE *file = _Py_fopen_obj(obj, "r+");
FARPROC pfopenobjFn;
typedef FILE* (*PFOPENOBJ)(PyObject*, char*);

//PyErr_Fetch( &pExcType , &pExcValue , &pExcTraceback ) ;
FARPROC pErrFetchFn;
typedef void (*PERRFETCH)(PyObject**,PyObject**,PyObject**);


HMODULE hModule = NULL;
char scriptPath[_MAX_PATH+1];

//PyAPI_FUNC(void) _Py_Dealloc(PyObject *);
//FARPROC pDeallocFn;
//typedef void (*PDEALLOC)(PyObject*);


//PyObject _Py_NoneStruct; /* Don't use this directly */
//#define Py_None (&_Py_NoneStruct)

//#define _Py_Dealloc(m) ((PDEALLOC)pDeallocFn)(m)

int initPy();



int loadPyDLL() {

//    lineout("loadpy",7);


    if ( hModule ) return 1;   //already loaded

	pInitializeExFn = NULL;

	// load the Python DLL
	LPCWSTR pDllName = L"pyembed/python38.dll" ;
	hModule = LoadLibraryW( pDllName ) ;
	if ( hModule == NULL ) {
		lineout("Could not load python dll",26);
		return 0;
	}

	// locate the Py_InitializeEx() function
	pInitializeExFn = GetProcAddress( hModule , "Py_InitializeEx" ) ;
	if( pInitializeExFn == NULL ) {		
		lineout("Could not find Py_InitializeEx()",33);
		hModule = NULL;
		return 0;
	}

	// locate the Py_SetPythonHome() function
	pSetPythonHomeFn = GetProcAddress( hModule , "Py_SetPythonHome" ) ;
	if( pSetPythonHomeFn == NULL ) {		
		lineout("Could not find Py_SetPythonHome()",34);
		hModule = NULL;
		return 0;
	}


	// locate the PyImport_AppendInittab() function
	pImport_AppendInittabFn = GetProcAddress( hModule , "PyImport_AppendInittab" ) ;
	if( pImport_AppendInittabFn == NULL ) {		
		lineout("Could not find PyImport_AppendInittab()",41);
		hModule = NULL;
		return 0;
	}

	// locate the PyRun_SimpleStringFlags() function
	pRun_SimpleStringFlags = GetProcAddress( hModule , "PyRun_SimpleStringFlags" ) ;
	if( pRun_SimpleStringFlags == NULL )  {		
		lineout("Could not find PyRun_SimpleStringFlags()",41);
		hModule = NULL;
		return 0;
	}
	
	// locate the PyUnicode_DecodeFSDefault() function
	pUnicode_DecodeFSDefaultFn = GetProcAddress( hModule , "PyUnicode_DecodeFSDefault" ) ;
	if(  pUnicode_DecodeFSDefaultFn == NULL )  {		
		lineout("Could not find PyUnicode_DecodeFSDefault()",43);
		hModule = NULL;
		return 0;
	}
	// locate PyImport_Import() function
	pImport_ImportFn = GetProcAddress( hModule , "PyImport_Import" ) ;
	if(  pImport_ImportFn == NULL )  {		
		lineout("Could not find PyImport_Import()",33);
		hModule = NULL;
		return 0;
	}
	// locate PyImport_ReloadModule() function
	pImport_ReloadModuleFn = GetProcAddress( hModule , "PyImport_ReloadModule" ) ;
	if(  pImport_ReloadModuleFn == NULL )  {		
		lineout("Could not find PyImport_ReloadModule()",39);
		hModule = NULL;
		return 0;
	}
	// locate PyMem_RawFree() function
	pMem_RawFreeFn = GetProcAddress( hModule , "PyMem_RawFree" ) ;
	if(  pMem_RawFreeFn == NULL )  {		
		lineout("Could not find PyMem_RawFree()",31);
		hModule = NULL;
		return 0;
	}
	// locate int Py_FinalizeEx() function
	pFinalizeExFn = GetProcAddress( hModule , "Py_FinalizeEx" ) ;
	if(  pFinalizeExFn == NULL )  {		
		lineout("Could not find Py_FinalizeEx()",31);
		hModule = NULL;
		return 0;
	}

	// locate int Py_DecodeLocale() function
	pDecodeLocaleFn = GetProcAddress( hModule , "Py_DecodeLocale" ) ;
	if(  pDecodeLocaleFn == NULL )  {		
		lineout("Could not find Py_DecodeLocale()",33);
		hModule = NULL;
		return 0;
	} 

	// locate int PyModule_Create2() function
	pModule_Create2Fn = GetProcAddress( hModule , "PyModule_Create2" ) ;
	if(  pModule_Create2Fn == NULL )  {		
		lineout("Could not find PyModule_Create2()",34);
		hModule = NULL;
		return 0;
	} 

	// locate PyArg_ParseTuple() function
	pArg_ParseTupleFn = GetProcAddress( hModule , "PyArg_ParseTuple" ) ;
	if(  pArg_ParseTupleFn == NULL )  {		
		lineout("Could not find PyArg_ParseTuple()",34);
		hModule = NULL;
		return 0;
	} 

	// locate Py_BuildValue() function
	pBuildValueFn = GetProcAddress( hModule , "Py_BuildValue" ) ;
	if(  pBuildValueFn == NULL )  {		
		lineout("Could not find Py_BuildValue()",31);
		hModule = NULL;
		return 0;
	} 


	// locate Py_BuildValue() function
	pRun_SimpleFileExFlagsFn = GetProcAddress( hModule , "PyRun_SimpleFileExFlags" ) ;
	if(  pRun_SimpleFileExFlagsFn == NULL )  {		
		lineout("Could not find PyRun_SimpleFileExFlags()",41);
		hModule = NULL;
		return 0;
	} 

	// locate _Py_fopen_obj() function
	pfopenobjFn = GetProcAddress( hModule , "_Py_fopen_obj" ) ;
	if(  pfopenobjFn == NULL )  {		
		lineout("Could not find _Py_fopen_obj()",31);
		hModule = NULL;
		return 0;
	} 


	// locate PyErr_Fetch() function
	pErrFetchFn = GetProcAddress( hModule , "PyErr_Fetch" ) ;
	if(  pErrFetchFn == NULL )  {		
		lineouts("Could not find PyErr_Fetch()");
		hModule = NULL;
		return 0;
	} 


/*	// locate _Py_Dealloc() function
	pDeallocFn = GetProcAddress( hModule , "_Py_Dealloc" ) ;
	if(  pDeallocFn == NULL )  {		
		lineout("Could not find _Py_Dealloc()",29);
		hModule = NULL;
		return 0;
	} 


//	_Py_NoneStruct = Py_BuildValue("");
	_Py_NoneStruct = *((PBUILDVALUE)pBuildValueFn)("");
*/

    initPy();
 
	return 1;
}


static PyObject*
redirection_stdoutredirect(PyObject *self, PyObject *args)
{
    const char *string;
	char s[] = "s";
//    if(!PyArg_ParseTuple(args, "s", &string))
    if(!((PARGPARSETUPLE)pArg_ParseTupleFn)(args, s, &string))
        return NULL;
    //pass string onto somewhere
        lineout(string, strlen(string));
//    Py_INCREF(Py_None);
//    return Py_None;
    return ((PBUILDVALUE)pBuildValueFn)("O",  ((PBUILDVALUE)pBuildValueFn)("")); // Inc ref to PyNone (without using INCREF macro which won't work here becuase of dynamic LoadLibrary
}

static PyMethodDef RedirectionMethods[] = {
    {"stdoutredirect", redirection_stdoutredirect, METH_VARARGS,
        "stdout redirection helper"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef stdoutRedirect =
{
    PyModuleDef_HEAD_INIT,
    "stdoutRedirect", /* name of module */
    "",          /* module documentation, may be NULL */
    -1,          /* size of per-interpreter state of the module, or -1 if the module keeps state in global variables. */
    RedirectionMethods
};

PyObject * PyInit_stdoutRedirect(void)
{
    return ((PMODULECREATE2)pModule_Create2Fn)(&stdoutRedirect, PYTHON_ABI_VERSION);
}


int runpy(const char *filename)
{

//    PyObject *pName, *pModule;   //, *pFunc;

	if (!loadPyDLL()) {
		return 130;
	}

	char a[] = "/";
	char *fullfile = (char*) malloc(strlen(filename)+strlen(scriptPath)+2);
	strcpy(fullfile,scriptPath);
	strcat(fullfile,a);
	strcat(fullfile,filename);

	lineout(fullfile,strlen(fullfile));

	PyObject *obj = NULL;
	struct stat buffer;   
	if (stat (fullfile, &buffer) == 0) {
		obj = ((PBUILDVALUE)pBuildValueFn)("s", fullfile);

		FILE *file = NULL;
		if ( obj != NULL ) {
			file = ((PFOPENOBJ)pfopenobjFn)(obj, "rb");

			if(file != NULL) {
				lineouts("Let's go");
				((PRUNSIMPLEFILEEXFLAGS)pRun_SimpleFileExFlagsFn)(file, fullfile,1,NULL);
			} else {
				lineouts("Could not open file");
			}

		} else {
			lineouts("Python filename string construction failed");
		}	


	} else {
		lineouts("File existence check failed");
	}
	
	

	lineouts("Done");

//	((PRUNSIMPLEFILEEXFLAGS)pRun_SimpleFileExFlagsFn)(pyfile, fullfile, 1, NULL);

//	lineout("Back",5);


//	free(fullfile);

//    pName = PyUnicode_DecodeFSDefault(filename);
//	pName = ((PUNICODE_DECODEFSDEFAULT)pUnicode_DecodeFSDefaultFn)(filename);

//    pModule = PyImport_Import(pName);
	//pModule = ((PIMPORT_IMPORT)pImport_ImportFn)(pName);
	//pModule = ((PIMPORT_IMPORT)pImport_ReloadModuleFn)(pName);

// Can't use DECREF when dynamically loading DLL.
//    Py_DECREF(pName);
//    if (pModule != NULL) {
 //     Py_DECREF(pModule);
//    }

//    PyMem_RawFree(wHomePath);
//	((PMEM_RAWFREE)pMem_RawFreeFn)(wHomePath);

//    if (Py_FinalizeEx() < 0) {
//    if ( ((PFINALIZEEX)pFinalizeExFn)() < 0) {
//        return 120;
//    }
    return 0;
}

int initPy() {
	
		
//    PyObject *pName, *pModule;   //, *pFunc;
//    PyObject *pArgs, *pValue;

// Set the PYTHONHOME to the CRYSTALS install folder + /pyembed

    char homePath[_MAX_PATH+1], exePath[_MAX_PATH+1];
    char drive[_MAX_DRIVE],  dir[_MAX_DIR];

    GetModuleFileNameA(NULL,exePath,_MAX_PATH+1);

    _splitpath_s( exePath, drive, _MAX_DRIVE, dir, _MAX_DIR, NULL, 0, NULL, 0 );
    _makepath_s( homePath, _MAX_PATH+1, drive, dir, "pyembed", NULL );
    _makepath_s( scriptPath, _MAX_PATH+1, drive, dir, "script", NULL );

//    lineout(homePath, strlen(homePath));

// Replace backslashes as they look like escape sequences when passed to Python.
    int index = 0;
    while(scriptPath[index]) {   // loop until null terminator
         if(scriptPath[index] == '\\')
            scriptPath[index] = '/';
         index++;
    }

    index = 0;
    while(homePath[index]) {   // loop until null terminator
         if(homePath[index] == '\\')
            homePath[index] = '/';
         index++;
    }

//    lineout(homePath, strlen(homePath));
//    wchar_t *wHomePath = Py_DecodeLocale(homePath, NULL);
    wchar_t *wHomePath = ((PDECODELOCALE)pDecodeLocaleFn)(homePath, NULL);


//    Py_SetPythonHome(wHomePath);
	((PSETPYTHONHOME)pSetPythonHomeFn)( wHomePath ) ;

// Add the stdoutRedirect module (defined above)
//    PyImport_AppendInittab("stdoutRedirect", PyInit_stdoutRedirect);
	int initt = ((PIMPORT_APPENDINITTAB)pImport_AppendInittabFn)("stdoutRedirect", PyInit_stdoutRedirect);


// call Py_InitializeEx()

//    Py_InitializeEx(0), but using the dynamically loaded function address.
	 ((PINITIALIZEEXFN)pInitializeExFn)( 0 ) ;


// This little bit tells python where to redirect stdout and stderr.
/*    PyRun_SimpleString("\  */

	((PRUN_SIMPLESTRINGFLAGS)pRun_SimpleStringFlags)("\
import stdoutRedirect\n\
import sys\n\
class StdoutCatcher:\n\
    def __init__(self):\n\
        self.errcatch = False \n\
    def write(self, textoutput):\n\
        if len(textoutput.rstrip('\\n')) != 0:\n\
          for s in textoutput.splitlines():\n\
            if self.errcatch:\n\
                s = '{E ' + s \n\
            stdoutRedirect.stdoutredirect(s)\n\
            \n\
    def flush(self):\n\
        pass\n\
        \n\
sys.stdout = StdoutCatcher()\n\
sys.stderr = StdoutCatcher()\n\
sys.stderr.errcatch = True\n", NULL);

//     lineout("done2",6);


// This little bit tells python where our scripts are.
    char str[_MAX_PATH + 36];
    sprintf(str, "import sys\nsys.path.append(\"%s\")\n", scriptPath);
//    PyRun_SimpleString( str );
	((PRUN_SIMPLESTRINGFLAGS)pRun_SimpleStringFlags)(str,NULL);


    return 0;
}



}   //end extern "C"