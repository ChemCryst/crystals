cd %CRYSBUILD%\manual
mkdir pdf
mkdir postscript
cd latex

pdflatex faq
pdflatex faq
makeindex faq.idx
pdflatex faq


pdflatex primer
pdflatex primer
makeindex primer.idx
pdflatex primer

pdflatex guide
pdflatex guide
makeindex guide.idx
pdflatex guide

pdflatex crystalsmanual
pdflatex crystalsmanual
makeindex crystalsmanual.idx
pdflatex crystalsmanual

pdflatex cameron
pdflatex cameron
makeindex cameron.idx
pdflatex cameron

pdflatex crysworkshop
pdflatex crysworkshop
makeindex crysworkshop.idx
pdflatex crysworkshop

pdflatex readme
pdflatex readme
makeindex readme.idx
pdflatex readme

pdflatex tools
pdflatex tools
makeindex tools.idx
pdflatex tools

