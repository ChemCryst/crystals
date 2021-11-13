include(FetchContent)


FetchContent_Declare(
  winembeddedpy
  URL https://www.python.org/ftp/python/3.10.0/python-3.10.0-embed-amd64.zip
  URL_HASH MD5=340408540EEFF359D5EAF93139AB90FD
)

FetchContent_MakeAvailable(winembeddedpy)

add_library(winembeddedpy INTERFACE)