if exist diff.lis del diff.lis
fc *.out "MIN64.ORG\*.out" > compare.lis
type diff.lis
