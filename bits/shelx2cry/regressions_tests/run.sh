#!/bin/sh

for path in insfiles/*; do
    [ -e "$path" ] || continue
    # ... rest of the loop body

    echo $path
    file=`basename "$path"`
    ../shelx2cry -o "${file}.out" -l "${file}.log" $path

    diff "${file}.out" "references/${file}.out"
done

