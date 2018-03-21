

enable_language(Fortran)


add_definitions(-DCRY_PY)

include_directories(../crystals)

add_library(PySpecific STATIC
pyspecific.F
)


add_library(CrystalsPyInterface STATIC
cinterface.cc
modelparameters.cc
cryspy.F
)

SET_TARGET_PROPERTIES(CrystalsPyInterface PROPERTIES LINKER_LANGUAGE C)


find_program(PYTHON "python")

if (PYTHON)
  set(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
  set(SETUP_PY "${CMAKE_CURRENT_BINARY_DIR}/../setup.py")
  set(DEPS "${CMAKE_CURRENT_SOURCE_DIR}/__init__.py")
  set(OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/build/timestamp")

  configure_file(${SETUP_PY_IN} ${SETUP_PY})
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cinterface.i cinterface.i)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/modelparameters.i modelparameters.i)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cinterface.h cinterface.h)
  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/modelparameters.h modelparameters.h)
  configure_file(${DEPS} ${CMAKE_CURRENT_BINARY_DIR}/../__init__.py)

  add_custom_command(OUTPUT ${OUTPUT}
    COMMAND ${PYTHON} ${SETUP_PY} build_ext --compiler=mingw32
    COMMAND ${CMAKE_COMMAND} -E touch ${OUTPUT}
    COMMAND ${PYTHON} ${SETUP_PY} bdist_msi
    COMMAND ${PYTHON} ${SETUP_PY} install
    DEPENDS ${DEPS})

  add_custom_target(target ALL DEPENDS ${OUTPUT})

#  install(CODE "execute_process(COMMAND ${PYTHON} ${SETUP_PY} install)")

endif()