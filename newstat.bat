if exist newstat.int del newstat.int
if exist newstat.lis del newstat.lis
if exist newstat.lis srt newstat.srt

svn status -u >newstat.int

 ecce-64 newstat.int newstat.lis <newstat.dat
sort newstat.lis >newstat.srt

if exist newstat.srt type newstat.srt
