
extern "C" {
	
#include <setjmp.h>
void setcommand(char *commandline);
void cxxgetcommand(int length, char *commandline);
static jmp_buf thebeginning;
void cryproc();
int kgedpy(int &ln,int &rn,float* output,int &on,int & nrecs,int & recln);

	
#ifdef CRY_OSWIN32
	#define PY_SSIZE_T_CLEAN
	#include <windows.h>
	#include <sys/stat.h>
#else
	#include <unistd.h>
#endif

#define Py_NO_ENABLE_SHARED 1  // Stop pyconfig trying to define which libraries to link to.

#ifdef _DEBUG   // Not sure this is needed.

	#undef _DEBUG //Prevent linking debug build of python
	#include <Python.h>   //Needed for the definitions of PyObject, PyModuleDef, etc.
	#define _DEBUG 1

#else

	#include <Python.h>   //Needed for the definitions of PyObject, PyModuleDef, etc.

#endif

#include <stdlib.h>


// What happens here?
//
// The routine runpy is the only entry point: it takes a filename and passes it to the Python interpreter to run.
//
// Some things to note:
//
// 1. On Windows, the DLL is loaded dynamically, therefore all the function addresses have to be explicitly looked up
//    and their interfaces specified here. If future DLLs change the interface, things will break.
// 2. On Windows, you can't pass FILE* pointers for files that you've opened to the DLL functions (different runtime library). 
//    Instead you can open files using a Python function _Py_fopen_obj and pass that pointer in. Now you know.
// 3. On initialization we setup a python module to redirect stdout and stderr from the python process back to us (in CRYSTALS),
//    so that we can output them to the screen.
// 4. After running a python file, we run another bit of Python code to clear any global variables to avoid unwanted side-effects
//    between running files. Only __builtin__ functions and crys_xxx variables are left unchanged. 


void lineout(const char* string, int);  // This is a FORTRAN function with C interface.

void lineouts(const char* string) {   // This wraps lineout so we don't need to pass the string length explicitly.
	lineout(string,(int)strlen(string)); 
}

//unsigned long GetModuleFileNameA( void * hModule, char * lpFilename, unsigned long nSize);

// For dynamic loading of python dll, we need to find the address of each function with a call
// to getprocaddress (these are stored in the global FARPROC pointers defined here). And we also
// need to know the function signature - this is a pain, because you have to explicitly (and correctly)
// set out each function here, but it is useful becuase we are not relying on Python.h. 
// If the function signatures change in future python releases, loading the new DLL here might not work.
// Another advantage of a dynamic load is that we can fail gracefully if python.dll is not found and carry
// on without it.


#ifdef CRY_OSWIN32
	// void Py_InitializeEx ( int )
	FARPROC pInitializeExFn;
	typedef void (*PINITIALIZEEXFN)( int ) ;
	#define mInitializeEx(i) ((PINITIALIZEEXFN)pInitializeExFn)(i)

	//PyAPI_FUNC(void) Py_SetPythonHome(const wchar_t *);
	FARPROC pSetPythonHomeFn;
	typedef void (*PSETPYTHONHOME)( const wchar_t *);

	FARPROC pImport_AppendInittabFn;
	typedef int (*PIMPORT_APPENDINITTAB)( const char *, PyObject *(*func)(void));
	#define mAppendInittab(c,p) ((PIMPORT_APPENDINITTAB)pImport_AppendInittabFn)(c,p)

	//PyAPI_FUNC(int) PyRun_SimpleStringFlags(const char *, PyCompilerFlags *);
	FARPROC pRun_SimpleStringFlags;
	typedef int (*PRUN_SIMPLESTRINGFLAGS)( const char *, PyCompilerFlags *);
	#define mRunSimpleStringFlags(str,flags) ((PRUN_SIMPLESTRINGFLAGS)pRun_SimpleStringFlags)(str,flags)

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
	typedef void (*PMEM_RAWFREE)(void*);
	//PyAPI_FUNC(void) PyMem_Free(void *ptr);
	FARPROC pMem_FreeFn;
	typedef void (*PMEM_FREE)(void*);
    #define mMemFree(p) ((PMEM_FREE)pMem_FreeFn)(p)

	// PyMem_Malloc(sizeof(wchar_t*)*argc);
	FARPROC pMem_MallocFn;
	typedef void* (*PMEM_MALLOC)( size_t n);
	#define mMem_Malloc(n) ((PMEM_MALLOC)pMem_MallocFn)(n)

	// PySys_SetArgv(int argc, wchar_t **argv);
	FARPROC pSys_SetArgvFn;
	typedef void (*PSYS_SETARGV)(int argc, wchar_t **argv);
	#define mSys_SetArgv(c,v) ((PSYS_SETARGV)pSys_SetArgvFn)(c,v)


	//int Py_FinalizeEx()
	FARPROC pFinalizeExFn;
	typedef int (*PFINALIZEEX)();

	// PyAPI_FUNC(wchar_t *) Py_DecodeLocale(const char *arg,size_t *size);
	FARPROC pDecodeLocaleFn;
	typedef wchar_t* (*PDECODELOCALE)(const char *, size_t *);
	#define mDecodeLocale(a,b) ((PDECODELOCALE)pDecodeLocaleFn)(a, b)

	// PyAPI_FUNC(PyObject *) PyModule_Create2(struct PyModuleDef*, int apiver);
	#define PYTHON_ABI_VERSION 3
	FARPROC pModule_Create2Fn;
	typedef PyObject* (*PMODULECREATE2)(PyModuleDef *, int);
	#define mModuleCreate2(a,b) ((PMODULECREATE2)pModule_Create2Fn)(a, b)

	// int (*py3_PyArg_ParseTuple)(PyObject *, char *, ...);
	FARPROC pArg_ParseTupleFn;
	typedef int (*PARGPARSETUPLE)(PyObject *, char *, ...);
	#define mArg_ParseTuple( args, s, string ) ((PARGPARSETUPLE)pArg_ParseTupleFn)(args, s, string)
	#define mArg_ParseTuple4( args, s, ptype, pobj ) ((PARGPARSETUPLE)pArg_ParseTupleFn)(args, s, ptype, pobj)

	// Py_ssize_t PyList_Size(PyObject *list);
	FARPROC pListSizeFn;
	typedef long long int (*PLISTSIZE)(PyObject *list);
	#define mList_Size( pList ) ((PLISTSIZE) pListSizeFn)( pList ) 


	//PyObject* PyList_GetItem(PyObject *list, Py_ssize_t index)
	FARPROC pList_GetItemFn;
	typedef PyObject* (*PLISTGETITEM)(PyObject *list, Py_ssize_t index);
	#define mList_GetItem( pList, index ) ((PLISTGETITEM) pList_GetItemFn)( pList, index ) 

	// (PyObject *) Py_BuildValue(const char *, ...);
	FARPROC pBuildValueFn;
	typedef PyObject* (*PBUILDVALUE)(const char *, ...);
	#define mBuildValue(...) ((PBUILDVALUE)pBuildValueFn)(__VA_ARGS__)
	

	//int PyRun_SimpleFileExFlags(FILE *fp, const char *filename, int closeit, PyCompilerFlags *flags)
	FARPROC pRun_SimpleFileExFlagsFn;
	typedef int (*PRUNSIMPLEFILEEXFLAGS)(FILE *fp, const char *filename, int closeit, PyCompilerFlags *flags);
	#define mRunSimpleFileExFlags(fp, fn, closeit, flags) ((PRUNSIMPLEFILEEXFLAGS)pRun_SimpleFileExFlagsFn)(fp, fn, closeit, flags)

	// PyObject* PyUnicode_AsUTF8String(PyObject *unicode)
	FARPROC pUnicodeAsUTF8String;
	typedef PyObject* (*PUNICODEASUTF8)(PyObject*);
	#define mUnicodeAsUTF8(uni) ((PUNICODEASUTF8)pUnicodeAsUTF8String)(uni)

	//char* PyBytes_AsString(PyObject *o)
	FARPROC pBytesAsStringFn;
	typedef char* (*PBYTESASSTRING)(PyObject*);
	#define mBytesAsString(obj) ((PBYTESASSTRING)pBytesAsStringFn)(obj)

	//void Py_DecRef(PyObject *o)
	FARPROC pDECREFfn;
	typedef void (*PDECREF)(PyObject *o);
	#define mDECREF(o) ((PDECREF)pDECREFfn)(o)


	//FILE *file = _Py_fopen_obj(obj, "r+");
	FARPROC pfopenobjFn;
	typedef FILE* (*PFOPENOBJ)(PyObject*, char*);
	#define mfopenobj(obj,flags) ((PFOPENOBJ)pfopenobjFn)(obj,flags)

	//PyErr_Fetch( &pExcType , &pExcValue , &pExcTraceback ) ;
	FARPROC pErrFetchFn;
	typedef void (*PERRFETCH)(PyObject**,PyObject**,PyObject**);


	FARPROC pErrSetStringFn = NULL;
	typedef void (*PERRSETSTRING)(PyObject*, const char*);
	#define mErrSetString(o,s) ((PERRSETSTRING)pErrSetStringFn)(o,s)

	//PyObject* PyList_New(Py_ssize_t len)
	FARPROC pListNewFn;
	typedef PyObject* (*PLISTNEW)(Py_ssize_t);
	#define mListNew(leng) ((PLISTNEW)pListNewFn)(leng)

	// PyObject* PyFloat_FromDouble(double v)
	FARPROC pFloatFromDoubleFn;
	typedef PyObject* (*PFLOATFROMDOUBLE)(double d);
	#define mFloatFromDouble(d) ((PFLOATFROMDOUBLE)pFloatFromDoubleFn)(d)


	HMODULE hModule = NULL;
#else

	#define _MAX_PATH 1024

	#define mInitializeEx(i) Py_InitializeEx(i)
	#define mRunSimpleStringFlags(str,flags) PyRun_SimpleStringFlags(str,flags)
	#define mRunSimpleFileExFlags(fp, fn, closeit, flags) PyRun_SimpleFileExFlags(fp, fn, closeit, flags)
	#define mfopenobj(obj,flags) _Py_fopen_obj(obj,flags)
    #define mArg_ParseTuple( args, s, string ) PyArg_ParseTuple( args, s, string )
	#define mArg_ParseTuple4( args, s, ptype, pobj ) PyArg_ParseTuple(args, s, ptype, pobj)
	#define mModuleCreate2(a,b) PyModule_Create2(a,b)
	#define mErrSetString(o,s) PyErr_SetString(o,s)
	#define mList_Size( pList ) PyList_Size( pList ) 
	#define mList_GetItem( pList, index ) PyList_GetItem( pList, index ) 
	#define mUnicodeAsUTF8(uni) PyUnicode_AsUTF8String(uni)
	#define mBytesAsString(obj) PyBytes_AsString(obj)
	#define mDECREF(o) Py_DecRef(o)
	#define mMemFree(p) PyMem_Free(p)

	#define mAppendInittab(c,p) PyImport_AppendInittab(c,p)
	#define mMem_Malloc(n) PyMem_Malloc(n)
	#define mSys_SetArgv(c,v) PySys_SetArgv(c,v)
	#define mDecodeLocale(a,b) Py_DecodeLocale(a, b)
	#define mBuildValue(...) Py_BuildValue(__VA_ARGS__)
	#define mListNew(leng) PyList_New(leng)
	#define mFloatFromDouble(d) PyFloat_FromDouble(d)


#endif


	PyTypeObject *ptr__List_Type = NULL; 
	PyObject **ptr__TypeError = NULL;



bool envInit = 0;

char scriptPath[_MAX_PATH+1];

int initPy();


int loadPyDLL() {

	if ( envInit ) return 1;  // already initialized.

#ifdef CRY_OSWIN32
	
	pInitializeExFn = NULL;

	// load the Python DLL
	LPCWSTR pDllName = L"pyembed/python38.dll" ;
	hModule = LoadLibraryW( pDllName ) ;
	if ( hModule == NULL ) {
		lineouts("{E Could not load python dll");
		return 0;
	}

	// locate the Py_InitializeEx() function
	pInitializeExFn = GetProcAddress( hModule , "Py_InitializeEx" ) ;
	if( pInitializeExFn == NULL ) {		
		lineouts("{E Could not find Py_InitializeEx()");
		hModule = NULL;
		return 0;
	}

	// locate the Py_SetPythonHome() function
	pSetPythonHomeFn = GetProcAddress( hModule , "Py_SetPythonHome" ) ;
	if( pSetPythonHomeFn == NULL ) {		
		lineouts("{E Could not find Py_SetPythonHome()");
		hModule = NULL;
		return 0;
	}


	// locate the PyImport_AppendInittab() function
	pImport_AppendInittabFn = GetProcAddress( hModule , "PyImport_AppendInittab" ) ;
	if( pImport_AppendInittabFn == NULL ) {		
		lineouts("{E Could not find PyImport_AppendInittab()");
		hModule = NULL;
		return 0;
	}

	// locate the PyRun_SimpleStringFlags() function
	pRun_SimpleStringFlags = GetProcAddress( hModule , "PyRun_SimpleStringFlags" ) ;
	if( pRun_SimpleStringFlags == NULL )  {		
		lineouts("{E Could not find PyRun_SimpleStringFlags()");
		hModule = NULL;
		return 0;
	}
	
	// locate the PyUnicode_DecodeFSDefault() function
	pUnicode_DecodeFSDefaultFn = GetProcAddress( hModule , "PyUnicode_DecodeFSDefault" ) ;
	if(  pUnicode_DecodeFSDefaultFn == NULL )  {		
		lineouts("{E Could not find PyUnicode_DecodeFSDefault()");
		hModule = NULL;
		return 0;
	}
	// locate PyImport_Import() function
	pImport_ImportFn = GetProcAddress( hModule , "PyImport_Import" ) ;
	if(  pImport_ImportFn == NULL )  {		
		lineouts("{E Could not find PyImport_Import()");
		hModule = NULL;
		return 0;
	}
	// locate PyImport_ReloadModule() function
	pImport_ReloadModuleFn = GetProcAddress( hModule , "PyImport_ReloadModule" ) ;
	if(  pImport_ReloadModuleFn == NULL )  {		
		lineouts("{E Could not find PyImport_ReloadModule()");
		hModule = NULL;
		return 0;
	}
	// locate PyMem_RawFree() function
	pMem_RawFreeFn = GetProcAddress(hModule, "PyMem_RawFree");
	if (pMem_RawFreeFn == NULL) {
		lineouts("{E Could not find PyMem_RawFree()");
		hModule = NULL;
		return 0;
	}
	// locate PyMem_Free() function
	pMem_FreeFn = GetProcAddress(hModule, "PyMem_Free");
	if (pMem_FreeFn == NULL) {
		lineouts("{E Could not find PyMem_Free()");
		hModule = NULL;
		return 0;
	}
	// locate int Py_FinalizeEx() function
	pFinalizeExFn = GetProcAddress( hModule , "Py_FinalizeEx" ) ;
	if(  pFinalizeExFn == NULL )  {		
		lineouts("{E Could not find Py_FinalizeEx()");
		hModule = NULL;
		return 0;
	}

	// locate int Py_DecodeLocale() function
	pDecodeLocaleFn = GetProcAddress( hModule , "Py_DecodeLocale" ) ;
	if(  pDecodeLocaleFn == NULL )  {		
		lineouts("{E Could not find Py_DecodeLocale()");
		hModule = NULL;
		return 0;
	} 


	// PyUnicode_AsUTF8String
	pUnicodeAsUTF8String = GetProcAddress( hModule, "PyUnicode_AsUTF8String" );
	if ( pUnicodeAsUTF8String == NULL ) {
		lineouts("{E Could not find PyUnicode_AsUTF8String()");
		hModule = NULL;
		return 0;
	} 

	// PyBytes_AsString
	pBytesAsStringFn = GetProcAddress( hModule, "PyBytes_AsString" );
	if ( pBytesAsStringFn == NULL ) {
		lineouts("{E Could not find PyBytes_AsString()");
		hModule = NULL;
		return 0;
	} 

	// locate int PyList_Size() function
	pListSizeFn = GetProcAddress( hModule , "PyList_Size" ) ;
	if(  pListSizeFn == NULL )  {		
		lineouts("{E Could not find PyList_Size()");
		hModule = NULL;
		return 0;
	} 

	// locate int PyList_Size() function
	pList_GetItemFn = GetProcAddress( hModule , "PyList_GetItem" ) ;
	if(  pList_GetItemFn == NULL )  {		
		lineouts("{E Could not find PyList_GetItem()");
		hModule = NULL;
		return 0;
	} 

	//void Py_DecRef(PyObject *o)
	pDECREFfn = GetProcAddress( hModule, "Py_DecRef" );
	typedef void (*PDECREF)(PyObject *o);
	if(  pDECREFfn == NULL )  {		
		lineouts("{E Could not find Py_DecRef()");
		hModule = NULL;
		return 0;
	} 


	// locate int PyModule_Create2() function
	pModule_Create2Fn = GetProcAddress( hModule , "PyModule_Create2" ) ;
	if(  pModule_Create2Fn == NULL )  {		
		lineouts("{E Could not find PyModule_Create2()");
		hModule = NULL;
		return 0;
	} 

	// locate PyArg_ParseTuple() function
	pArg_ParseTupleFn = GetProcAddress( hModule , "PyArg_ParseTuple" ) ;
	if(  pArg_ParseTupleFn == NULL )  {		
		lineouts("{E Could not find PyArg_ParseTuple()");
		hModule = NULL;
		return 0;
	} 

	// locate Py_BuildValue() function
	pBuildValueFn = GetProcAddress( hModule , "Py_BuildValue" ) ;
	if(  pBuildValueFn == NULL )  {		
		lineouts("{E Could not find Py_BuildValue()");
		hModule = NULL;
		return 0;
	} 


	// locate Py_BuildValue() function
	pRun_SimpleFileExFlagsFn = GetProcAddress( hModule , "PyRun_SimpleFileExFlags" ) ;
	if(  pRun_SimpleFileExFlagsFn == NULL )  {		
		lineouts("{E Could not find PyRun_SimpleFileExFlags()");
		hModule = NULL;
		return 0;
	} 

	// locate _Py_fopen_obj() function
	pfopenobjFn = GetProcAddress( hModule , "_Py_fopen_obj" ) ;
	if(  pfopenobjFn == NULL )  {		
		lineouts("{E Could not find _Py_fopen_obj()");
		hModule = NULL;
		return 0;
	} 


	// locate PyErr_Fetch() function
	pErrFetchFn = GetProcAddress( hModule , "PyErr_Fetch" ) ;
	if(  pErrFetchFn == NULL )  {		
		lineouts("{E Could not find PyErr_Fetch()");
		hModule = NULL;
		return 0;
	} 

	// locate PyErr_SetString() function
	pErrSetStringFn = GetProcAddress( hModule , "PyErr_SetString" ) ;
	if(  pErrSetStringFn == NULL )  {		
		lineouts("{E Could not find PyErr_SetString()");
		hModule = NULL;
		return 0;
	} 

	//pSys_SetArgv
	pSys_SetArgvFn = GetProcAddress( hModule , "PySys_SetArgv" ) ;
	if(  pSys_SetArgvFn == NULL )  {		
		lineouts("{E Could not find PySys_SetArgv()");
		hModule = NULL;
		return 0;
	} 

	//	PyList_New
	pListNewFn = GetProcAddress( hModule , "PyList_New" ) ;
	if(  pListNewFn == NULL )  {		
		lineouts("{E Could not find PyList_New()");
		hModule = NULL;
		return 0;
	} 
	
	// PyFloat_FromDouble
	pFloatFromDoubleFn = GetProcAddress( hModule , "PyFloat_FromDouble" ) ;
	if(  pFloatFromDoubleFn == NULL )  {		
		lineouts("{E Could not find PyFloat_FromDouble()");
		hModule = NULL;
		return 0;
	} 


	//PyMem_Malloc
	pMem_MallocFn= GetProcAddress( hModule , "PyMem_Malloc" ) ;
	if(  pMem_MallocFn == NULL )  {		
		lineouts("{E Could not find PyMem_Malloc()");
		hModule = NULL;
		return 0;
	} 


	ptr__List_Type = (PyTypeObject*) GetProcAddress( hModule, "PyList_Type" );
	if(  ptr__List_Type == NULL )  {		
		lineouts("{E Could not find PyList_Type");
		hModule = NULL;
		return 0;
	} 

	ptr__TypeError = (PyObject**) GetProcAddress( hModule, "PyExc_TypeError" );
	if(  ptr__TypeError == NULL )  {		
		lineouts("{E Could not find PyExc_TypeError");
		hModule = NULL;
		return 0;
	} 

#endif

	envInit = 1;   //Everything is initialized. Don't init again.

    initPy();
 
	return 1;
}



// This python module, "crys_stdoutRedirect", implemented in C will be used later to redirect text
// output from the interpreter while it is running. Text should end up on the
// screen in CRYSTALS.
// Solution discussed here: https://stackoverflow.com/questions/7935975/asynchronously-redirect-stdout-stdin-from-embedded-python-to-c
// and updates required for Python 3 here:
// https://stackoverflow.com/questions/28305731/compiler-cant-find-py-initmodule-is-it-deprecated-and-if-so-what-should-i


//int initt = ((PIMPORT_APPENDINITTAB)pImport_AppendInittabFn)("crys_stdoutRedirect", PyInit_crys_stdoutRedirect);
// This defines a function (and it's form) to do the work:
// Takes one arg and returns nothing.


static PyObject*
redirection_stdoutredirect(PyObject *self, PyObject *args)
{
    const char *string;
	char s[] = "s";

    if(!mArg_ParseTuple(args, s, &string))
        return NULL;

//pass string onto somewhere
    lineouts(string);

#ifdef CRY_OSWIN32
    return mBuildValue("O",  mBuildValue("")); // Inc ref to PyNone (without using INCREF macro which won't work here becuase of dynamic LoadLibrary
#else
    Py_INCREF(Py_None);   // Can't call this macro when using the dynamic DLL version - use solution below instead.
    return Py_None;
#endif

}

static PyMethodDef RedirectionMethods[] = {
    {"crys_stdoutredirect", redirection_stdoutredirect, METH_VARARGS,
        "stdout redirection helper"},
    {NULL, NULL, 0, NULL}
};

static struct PyModuleDef crys_stdoutRedirect =
{
    PyModuleDef_HEAD_INIT,
    "crys_stdoutRedirect", /* name of module */
    "",          /* module documentation, may be NULL */
    -1,          /* size of per-interpreter state of the module, or -1 if the module keeps state in global variables. */
    RedirectionMethods
};

PyObject * PyInit_crys_stdoutRedirect(void)
{
    return mModuleCreate2(&crys_stdoutRedirect, PYTHON_ABI_VERSION);
}

// Here's another Python module for sending commands to CRYSTALS.


static PyObject*
method_crys_run(PyObject *self, PyObject *args)
{
	PyObject *pyList;
	PyObject *pyItem;
	PyObject *pyString;
	Py_ssize_t list_size;
	int i;
	
	if (!mArg_ParseTuple4(args, "O!", ptr__List_Type, &pyList)) {
//		lineouts("1.1");
		mErrSetString(*ptr__TypeError, "first argument must be a list.");
//		lineouts("1.2");
		return NULL;
	}

	list_size = mList_Size(pyList);

	for (i=0; i<list_size; i++) {
		pyItem = mList_GetItem(pyList, i);
		if(!PyUnicode_Check(pyItem)) {
			mErrSetString(*ptr__TypeError, "list items must be strings.");
			return NULL;
		}
		pyString = mUnicodeAsUTF8(pyItem);
		
		
		char* val;
		if(pyString) {
			val =  mBytesAsString(pyString) ;
			mDECREF(pyString);
			
			//pass string onto somewhere
			lineouts(val);
			setcommand(val);
		}
	}

    i = setjmp(thebeginning);
    if ( i == 0 ) {                    // This is the first path.
//		printf("Calling ccommand.\n");
		cryproc();
    }
    else {                             // This is where we return to on longjmp.
//		printf("Longjmp back to start.\n");
    }

#ifdef CRY_OSWIN32
    return mBuildValue("O",  mBuildValue("")); // Inc ref to PyNone (without using INCREF macro which won't work here becuase of dynamic LoadLibrary
#else
    Py_INCREF(Py_None);   // Can't call this macro when using the dynamic DLL version - use solution below instead.
    return Py_None;
#endif

}

static PyObject*
method_crys_get(PyObject *self, PyObject *args)
{
/*
	if (!mArg_ParseTuple4(args, "O!", ptr__List_Type, &pyList)) {
		mErrSetString(*ptr__TypeError, "first argument must be a list.");
		return NULL;
	}

	list_size = mList_Size(pyList);

	for (i=0; i<list_size; i++) {
		pyItem = mList_GetItem(pyList, i);
		if(!PyUnicode_Check(pyItem)) {
			mErrSetString(*ptr__TypeError, "list items must be strings.");
			return NULL;
		}
		pyString = mUnicodeAsUTF8(pyItem);
		
		
		char* val;
		if(pyString) {
			val =  mBytesAsString(pyString) ;
			mDECREF(pyString);
			
			//pass string onto somewhere
			lineout(val, strlen(val));
			setcommand(val);
		}
	}

    i = setjmp(thebeginning);
    if ( i == 0 ) {                    // This is the first path.
//		printf("Calling ccommand.\n");
		cryproc();
    }
    else {                             // This is where we return to on longjmp.
//		printf("Longjmp back to start.\n");
    }
*/

    int nrecs = -1;
    int recln = -1;
    int ln = 5;
	int rn = 101;
	int osize = 0;
    int res = kgedpy(ln,rn, NULL, osize, nrecs, recln);
	
	osize = res;
	lineouts("got");
	
	float *output = (float*) malloc(osize * sizeof(float)); 

	res = kgedpy(ln,rn, output, osize, nrecs, recln);

    char str[512]; // debugging output

    sprintf(str, "Res, nrec, recl: %d, %d, %d", res, nrecs, recln);
    lineouts(str);


	PyObject *result = mListNew((Py_ssize_t)nrecs);
	for (Py_ssize_t i = 0; i < nrecs; i++) {
		PyObject *record = mListNew((Py_ssize_t)recln);
		for (Py_ssize_t j = 0; j < recln; j++)
			PyList_SET_ITEM(record, j, mFloatFromDouble(output[i*recln+j]));
		PyList_SET_ITEM(result, i, record);
	}

    free (output);


//	PyObject * python_val = mBuildValue("[ii]", 19, 84);
    return result;

}


// What's in here? Just CrystalsModuleMethods - another simple structure:

static PyMethodDef CrystalsModuleMethods[] = {
    {"run", method_crys_run, METH_VARARGS,
        "Run CRYSTALS commands helper"},
    {"get", method_crys_get, METH_VARARGS,
        "Get information from CRYSTALS"},
    {NULL, NULL, 0, NULL}
};

// This just calls and returns an object from modulecreate with the name of a struct that defines the function:
static struct PyModuleDef crystals_module =
{
    PyModuleDef_HEAD_INIT,
    "crystals", /* name of module */
    "",          /* module documentation, may be NULL */
    -1,          /* size of per-interpreter state of the module, or -1 if the module keeps state in global variables. */
    CrystalsModuleMethods
};


// Adds a module to the interpreter (same as import would), defines name and function. 
// Here is the function:
PyObject * PyInit_crystals_module(void)
{
    return mModuleCreate2(&crystals_module, PYTHON_ABI_VERSION);
}



// Here's the entry point.


int runpy(const char *filename)    // filename can be a while command line. Tokenize it here.
{

// Load DLL and initialize , if not already loaded
	if (!loadPyDLL()) {
		return 130;
	}

// Make a copy. The upcoming strtok needs to overwrite the string buffer.
	char *commandline = (char*) malloc(strlen(filename) + 1);
	strcpy(commandline,filename);


	enum { kMaxArgs = 64 };
	int argc = 0;
	char *argv[kMaxArgs];
	
	char *p2 = strtok(commandline, " ");
	while (p2 && argc < kMaxArgs-1)
	{
		argv[argc++] = p2;
		p2 = strtok(0, " ");
	}
	argv[argc] = 0;

	if ( argc == 0 ) {
		lineouts("{E Python filename required");
		return 140;
	}	


	wchar_t** wargv = (wchar_t**) mMem_Malloc(sizeof(wchar_t*)*argc);
	for (int i=0; i<argc; i++) {
		wchar_t* arg = mDecodeLocale(argv[i], NULL);
		wargv[i] = arg;
	}

	struct stat buffer;   
	char a[] = "/";
	char *fullfile = (char*) malloc(strlen(argv[0])+strlen(scriptPath)+5);
	strcpy(fullfile,scriptPath);
	strcat(fullfile,a);
	strcat(fullfile,argv[0]);

//	lineouts("filename");
//	lineouts(fullfile);

	if (stat (fullfile, &buffer) != 0) {  // try adding .py extension
		char p[] = ".py";
		strcat(fullfile,p);
	}


	mSys_SetArgv(argc, wargv);
	

	PyObject *obj = NULL;
	if (stat (fullfile, &buffer) == 0) {
		obj = mBuildValue("s", fullfile);
		FILE *file = NULL;
		if ( obj != NULL ) {

			file = mfopenobj(obj, "rb");
			if(file != NULL) {
//				lineouts("Let's go");
				mRunSimpleFileExFlags(file, fullfile,1,NULL);
			} else {
				lineouts("{E Could not open file");
			}

		} else {
			lineouts("{E Python filename string construction failed");
		}	

	} else {
		lineouts("{E File existence check failed");
		lineouts(fullfile);
	}
	mMemFree(wargv);

	free(fullfile);

	free(commandline);

// IMPORTANT: This little bit of code deletes all global variables from the global namespace, with
// the exception of builtin functions (starting with __) and any functions or variables starting with
// crys_ . These crys_ vars are used for our redirection functions, but can also be used to deliberately pass // info between scripts.
// This approach avoids restarting the interpreter between scripts, and prevents unintended side effects
// of leaving global variables defined.

	mRunSimpleStringFlags("\
for variable in dir():\n\
    if variable[0:2] != \"__\" and variable[0:5] != \"crys_\" :\n\
        del globals()[variable]\n", NULL);

    return 0;
}







// This is called from the end of loadPyDLL() - it sets up the stdout redirection
int initPy() {
	
		
//    PyObject *pName, *pModule;   //, *pFunc;
//    PyObject *pArgs, *pValue;

// Set the PYTHONHOME to the CRYSTALS install folder + /pyembed

    char homePath[_MAX_PATH+1], exePath[_MAX_PATH+1];
//    char drive[_MAX_DRIVE],  dir[_MAX_DIR];

#ifdef CRY_OSWIN32
    GetModuleFileNameA(NULL,exePath,_MAX_PATH+1);
#else
	ssize_t len;
	if ((len = readlink("/proc/self/exe", exePath, sizeof(exePath)-1)) != -1)
		exePath[len] = '\0';
#endif

// shorten exePath a last slash to remove filename 
	char *slash = &exePath[0], *next;
	while ((next = strpbrk(slash + 1, "\\/"))) slash = next;
    if (&exePath[0] != slash) slash++;
	*slash = '\0';

	char pe[] = "pyembed";
	strcpy(homePath,exePath);
	strcat(homePath,pe);

	char sc[] = "script";
	strcpy(scriptPath,exePath);
	strcat(scriptPath,sc);

//    _splitpath_s( exePath, drive, _MAX_DRIVE, dir, _MAX_DIR, NULL, 0, NULL, 0 );
//    _makepath_s( homePath, _MAX_PATH+1, drive, dir, "pyembed", NULL );
//    _makepath_s( scriptPath, _MAX_PATH+1, drive, dir, "script", NULL );

//    lineouts(homePath);
//    lineouts(scriptPath);

// Replace backslashes as they look like escape sequences when passed to Python.
#ifdef CRY_OSWIN32
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
#endif

//    lineout(homePath, strlen(homePath));
#ifdef CRY_OSWIN32
    wchar_t *wHomePath = mDecodeLocale(homePath, NULL);
#else
//    wchar_t *wHomePath = Py_DecodeLocale(homePath, NULL);
#endif


#ifdef CRY_OSWIN32
	((PSETPYTHONHOME)pSetPythonHomeFn)( wHomePath ) ;
#else    
//	Py_SetPythonHome(wHomePath);
#endif

// Add the crys_stdoutRedirect module (defined above)
	int initt = mAppendInittab("crys_stdoutRedirect", PyInit_crys_stdoutRedirect);
	int initt2 = mAppendInittab("crystals", PyInit_crystals_module);

    mInitializeEx(0);

// This little bit tells python where to redirect stdout and stderr.


	mRunSimpleStringFlags("\
import crys_stdoutRedirect\n\
import sys\n\
class crys_StdoutCatcher:\n\
    def __init__(self):\n\
        self.errcatch = False \n\
    def write(self, textoutput):\n\
        if len(textoutput.rstrip('\\n')) != 0:\n\
          for s in textoutput.splitlines():\n\
            if self.errcatch:\n\
                s = '{E ' + s \n\
            crys_stdoutRedirect.crys_stdoutredirect(s)\n\
            \n\
    def flush(self):\n\
        pass\n\
        \n\
sys.stdout = crys_StdoutCatcher()\n\
sys.stderr = crys_StdoutCatcher()\n\
sys.stderr.errcatch = True\n", NULL);

// This little bit tells python where our scripts are.
    char str[_MAX_PATH + 36];
    sprintf(str, "import sys\nsys.path.append(\"%s\")\n", scriptPath);


	mRunSimpleStringFlags(str,NULL);

//#ifdef CRY_OSWIN32
//	((PRUN_SIMPLESTRINGFLAGS)pRun_SimpleStringFlags)(str,NULL);
//#else
    //PyRun_SimpleString( str );
//#endif

    return 0;
}


/*  Calling CRYSTALS ADMIN stuff */


// Call this to force a longjmp back to where the routine above.
void endofcommands(){
//		printf("pointer %d \n", (long*)thebeginning) ;
		longjmp(thebeginning,1);
}

void getcommand(int length, char *commandline)
{
    cxxgetcommand(length, commandline);  //Call the C++ version (below)
}



}   //end extern "C"


// This is C++ stuff

#include <deque>
#include <string>

std::deque <std::string> commands;








void setcommand(char *commandline){
	commands.push_back( std::string(commandline) );
}

// Copy next string into commandline buffer, return 0 for OK, < 0 for error.
// Request past end of commands causes a longjmp back to start point (out of CRYSTALS)
void cxxgetcommand(int length, char *commandline)
{
	if ( commands.size() > 0 )
	{
		std::string s = commands.front();
		commands.pop_front();

        int commandlen = (int)s.length();
		int outputlen = (length < commandlen) ? length : commandlen;  //Minimum of the two string lengths (truncate)

// Remember: char * strncpy ( char * destination, const char * source, size_t num );

		strncpy(commandline, (char*)s.c_str(), outputlen ); 
		//PAD
        for (int j = commandlen; j<length; j++)   //Copy
		{
			*(commandline + j) = ' ';
		}
		
	}
	else
	{
		endofcommands();
	}
	return;
}








/*  ric.py 

import crystals

print("Hello Richard")

print( dir(crystals) )


# crystals.run("Hi........")  - passing wrong object crashes program : investigate

crystals.run( ['Hi','These are strings','','Useful or not?'] )

*/