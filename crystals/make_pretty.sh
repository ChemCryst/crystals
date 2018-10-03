#!/bin/bash

command -v fprettify >/dev/null 2>&1 || { echo >&2 "I require fprettify but it's not installed.  Aborting."; exit 1; }

if [ $# -eq 0 ] ; then
  for i in $( ls *.F90 ); do
    echo fprettify: $i
    fprettify -i 2 -w 1 $i
  done
else
  for file in "$@"; do
    echo fprettify: $file
    fprettify -i 2 -w 1 $file
  done
fi

