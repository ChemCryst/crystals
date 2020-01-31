if exist diff.lis del diff.lis
fc *.out "MIN64.ORG\*.out" > diff.lis
type diff.lis
