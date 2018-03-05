TEXNAME=design
TEXFILE=$(TEXNAME).tex

all:
	#make svg
	make pdf
	make pdf
	make clean

svg:
	inkscape -D -z --file=ti84.svg --export-pdf=ti84.pdf --export-latex
	inkscape -D -z --file=z80.svg --export-pdf=z80.pdf --export-latex
	inkscape -D -z --file=asic.svg --export-pdf=asic.pdf --export-latex

pdf:
	pdflatex -shell-escape $(TEXFILE)

clean:
	rm -f *.{out,aux,log,toc,pdf_tex}
	rm -f ti84.pdf z80.pdf
