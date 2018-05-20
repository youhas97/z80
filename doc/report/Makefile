TEXNAME=main
TEXFILE=$(TEXNAME).tex
BIBFILE=references.bib
TEXOPTS=--shell-escape

all:
	make report
	make bib
	make pdf
	make pdf
	make clean

report:
	latex $(TEXOPTS) $(TEXFILE)

bib:
	bibtex8 $(TEXNAME)

pdf:
	pdflatex $(TEXOPTS) $(TEXFILE)

clean:
	rm -f *.{aux,bbl,blg,dvi,log,out,xml,toc} *blx.bib
