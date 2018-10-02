#!/bin/bash

command -v fprettify >/dev/null 2>&1 || { echo >&2 "I require fprettify but it's not installed.  Aborting."; exit 1; }

for i in $( ls *.F90 ); do
  echo fprettify: $i
  fprettify -i 2 -w 1 $i
done
