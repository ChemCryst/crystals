#!/bin/sh

for path in insfiles/*.ins; do
    [ -e "$path" ] || continue
    # ... rest of the loop body

    file=`basename "$path"`
    echo $file
    ../shelx2cry -o "${file}.out" -l "${file}.log" $path > /dev/null

    diff -q "${file}.out" "references/${file}.out"
    diff -q "${file}.log" "references/${file}.log"

done

