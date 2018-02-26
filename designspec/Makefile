TEXNAME=design
TEXFILE=$(TEXNAME).tex

all:
	make svg
	make pdf
	make pdf
	make clean

svg: ti84.svg z80.svg
	inkscape -D -z --file=ti84.svg --export-pdf=ti84.pdf --export-latex
	inkscape -D -z --file=z80.svg --export-pdf=z80.pdf --export-latex

pdf:
	pdflatex -shell-escape $(TEXFILE)

clean:
	rm *.{out,aux,log,toc,pdf_tex}
	rm ti84.pdf z80.pdf
