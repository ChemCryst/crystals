if exist newstat.int del newstat.int
if exist newstat.lis del newstat.lis
if exist newstat.lis srt newstat.srt

svn status >newstat.int

rem ecce newstat.int newstat.lis newstat.dat
sort newstat.int >newstat.srt

if exist newstat.srt type newstat.srt
