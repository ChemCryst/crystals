#!/bin/sh

for path in insfiles/*.ins; do
    [ -e "$path" ] || continue
    # ... rest of the loop body

    file=`basename "$path"`
    echo 
    echo $file
    ../shelx2cry -o "${file}.out" -l "${file}.log" $path > "${file}.stdout"

    diff  --strip-trailing-cr -q "${file}.out" "references/${file}.out"
    diff  --strip-trailing-cr -q "${file}.log" "references/${file}.log"
    diff  --strip-trailing-cr -q "${file}.stdout" "references/${file}.stdout"

done

