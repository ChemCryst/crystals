
"""
setup.py file for CrysPy 
"""

from distutils.core import setup, Extension


cryspy_module = Extension('cryspy',
                           sources=['cryspy.c'],
                           library_dirs=['../p/crystals'], 
						   libraries=['CrystalsShared','gfortran','openblas'],
                           )
	   

setup (name = 'cryspy',
       version = '0.2',
       author      = "Richard Cooper",
       description = """Level 0 CRYSTALS Python API from SWIG""",
       ext_modules = [cryspy_module],
       py_modules = ["cryspy"],
       )
     