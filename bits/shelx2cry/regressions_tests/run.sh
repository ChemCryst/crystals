#!/bin/bash

difffail=0

for path in insfiles/*.ins; do
    [ -e "$path" ] || continue
    # ... rest of the loop body

    file=`basename "$path"`
    echo
    echo $file
    ../shelx2cry -o "${file}.out" -l "${file}.log" $path > "${file}.stdout"

    diff  --strip-trailing-cr  "${file}.out" "references/${file}.out"
    if [ $? -ne 0 ]
    then
      difffail=1
    fi
    diff  --strip-trailing-cr  "${file}.log" "references/${file}.log"
    if [ $? -ne 0 ]
    then
      difffail=1
    fi
    diff  --strip-trailing-cr  "${file}.stdout" "references/${file}.stdout"
    if [ $? -ne 0 ]
    then
      difffail=1
    fi
done

exit $difffail
