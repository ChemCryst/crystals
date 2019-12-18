#define PY_SSIZE_T_CLEAN
#include <Python.h>
#include <stdlib.h>

void zmore_(char* m, int i);

// This python module, implemented in C will be used later to redirect text
// output from the interpreter while it is running. Text should end up on the
// screen in CRYSTALS.
// Solution discussed here: https://stackoverflow.com/questions/7935975/asynchronously-redirect-stdout-stdin-from-embedded-python-to-c
// and updates required for Python 3 here:
// https://stackoverflow.com/questions/28305731/compiler-cant-find-py-initmodule-is-it-deprecated-and-if-so-what-should-i

static PyObject*
redirection_stdoutredirect(PyObject *self, PyObject *args)
{
    const char *string;
    if(!PyArg_ParseTuple(args, "s", &string))
        return NULL;
    //pass string onto somewhere
        lineout(string, strlen(string));
    Py_INCREF(Py_None);
    return Py_None;
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

PyMODINIT_FUNC PyInit_stdoutRedirect(void)
{
    return PyModule_Create(&stdoutRedirect);
}


int runpy(const char *filename)
{
    PyObject *pName, *pModule;   //, *pFunc;
//    PyObject *pArgs, *pValue;

// Set the PYTHONHOME to the CRYSTALS install folder + /pyembed

    wchar_t myPath[_MAX_PATH+1];
    GetModuleFileNameW(NULL,myPath,_MAX_PATH);

    wchar_t drive[_MAX_DRIVE];
    wchar_t dir[_MAX_DIR];
    _wsplitpath_s( myPath, drive, _MAX_DRIVE, dir, _MAX_DIR, NULL, 0, NULL, 0 );
    _wmakepath_s( myPath, _MAX_PATH+1, drive, dir, L"pyembed", NULL );

//    Py_SetPythonHome(L"c:/msys64/mingw64");
//    Py_SetPythonHome(L"c:/users/richard.cooper/Documents/Github/crystals/p/pyembed");
    Py_SetPythonHome(myPath);


/*
// If initialization fails, uncomment
// this section to find out what is going wrong.
    AllocConsole();
    freopen("CONIN$", "r", stdin);
    freopen("CONOUT$", "a", stdout);
    freopen("CONOUT$", "a", stderr);

    printf("Top of call\n");
    sprintf(message,"Top of call\n");
    lineout(message,256);*/

// Add the stdoutRedirect module
    PyImport_AppendInittab("stdoutRedirect", PyInit_stdoutRedirect);

    Py_Initialize();

// This little bit tells python where to redirect stdout.
    PyRun_SimpleString("\
import stdoutRedirect\n\
import sys\n\
class StdoutCatcher:\n\
    def __init__(self):\n\
        self.errcatch = False \n\
    def write(self, textoutput):\n\
        if len(textoutput.rstrip()) != 0:\n\
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
sys.stderr.errcatch = True\n");


    pName = PyUnicode_DecodeFSDefault(filename);
    /* Error checking of pName left out */

//    FILE* fp = fopen(filename, "rb");
//    int pyret = PyRun_SimpleFile(fp, filename);

//    return pyret;


    pModule = PyImport_Import(pName);
    Py_DECREF(pName);
    if (pModule != NULL) {
      Py_DECREF(pModule);
    } else {
      lineout("Couldn't find python module with that name",42);
    }
/*
    if (pModule != NULL) {
        pFunc = PyObject_GetAttrString(pModule, "__main__");
        // pFunc is a new reference
*/
/*
        if (pFunc && PyCallable_Check(pFunc)) {
            pValue = PyObject_CallObject(pFunc, NULL);
            if (pValue != NULL) {
                sprintf(message,"Result of call: %ld\n", PyLong_AsLong(pValue));
                Py_DECREF(pValue);
            }
            else {
                Py_DECREF(pFunc);
                Py_DECREF(pModule);
                PyErr_Print();
                sprintf(message,"Call failed\n");
                lineout(message,256);
                return 1;
            }
        }
        else {
            if (PyErr_Occurred())
                PyErr_Print();
            sprintf(message, "Cannot find function \"%s\"\n", "__main__");
        }
        Py_XDECREF(pFunc);
        Py_DECREF(pModule);
    }
    else {
        PyErr_Print();
        sprintf(message, "Failed to load \"%s\"\n", "argv[1]");
        return 1;
    }
*/
    if (Py_FinalizeEx() < 0) {
        return 120;
    }
    return 0;
}
