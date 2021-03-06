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

svg: svg/rf_baddr.svg
	inkscape -z --file=svg/board.svg --export-eps=board.eps
	\
	inkscape -z --file=svg/Z80_arch.svg --export-eps=z80arch.eps
	inkscape -z --file=svg/Z80_pinout.svg --export-eps=z80pins.eps
	\
	inkscape -z --file=svg/rf_baddr.svg --export-eps=rfbaddr.eps
	inkscape -z --file=svg/alu_sbc.svg --export-eps=alusbc.eps
	inkscape -z --file=svg/port.svg --export-eps=port.eps
	\
	inkscape -z --file=svg/cpu_instr_m1t1.svg --export-eps=m1t1.eps
	inkscape -z --file=svg/cpu_instr_m1t2.svg --export-eps=m1t2.eps
	inkscape -z --file=svg/cpu_instr_m1t3.svg --export-eps=m1t3.eps
	inkscape -z --file=svg/cpu_instr_m1t4.svg --export-eps=m1t4.eps
	inkscape -z --file=svg/cpu_instr_m2t2.svg --export-eps=m2t2.eps
	\
	inkscape -z --file=svg/vga.svg --export-eps=vga.eps
	inkscape -z --file=svg/monitor.svg --export-eps=monitor.eps
	\
	inkscape -z --file=svg/comp.svg --export-eps=comp.eps
	inkscape -z --file=svg/cpu.svg --export-eps=cpu.eps
	inkscape -z --file=svg/alu.svg --export-eps=alu.eps
	inkscape -z --file=svg/ti.svg --export-eps=ti.eps
pdf:
	pdflatex $(TEXOPTS) $(TEXFILE)

clean:
	rm -f *.aux *.bbl *.blg *.dvi *.log *.out *.xml *.toc *blx.bib
	rm -f img/*converted*
	rm -f *.eps *converted-to.pdf
