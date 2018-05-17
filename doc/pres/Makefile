INK_FLAGS = --without-gui --export-area-page --export-dpi=360

all:
	make comp
	make ti
	make timings
	make prgm

comp: comp.svg
	inkscape $(INK_FLAGS) --file=comp.svg --export-png=comp.png
ti: ti.svg
	inkscape $(INK_FLAGS) --file=ti.svg --export-png=ti.png
timings: timings.svg
	inkscape $(INK_FLAGS) --file=timings.svg --export-png=timings.png
prgm: prgm.svg
	inkscape $(INK_FLAGS) --file=prgm.svg --export-png=prgm.png
