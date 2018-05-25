TEXNAME=main
TEXFILE=$(TEXNAME).tex
BIBFILE=references.bib
TEXOPTS=--shell-escape

all:
	make svg
	make report
	make bib
	make pdf
	make pdf
	make clean

report:
	latex $(TEXOPTS) $(TEXFILE)

bib:
	bibtex8 $(TEXNAME)

svg: svg/cpu.svg
	inkscape -z --file=svg/cpu.svg --export-eps=cpu.eps

pdf:
	pdflatex $(TEXOPTS) $(TEXFILE)

clean:
	rm -f *.aux *.bbl *.blg *.dvi *.log *.out *.xml *.toc *blx.bib
	rm -f *.pdf_tex cpu.pdf alu.pdf
