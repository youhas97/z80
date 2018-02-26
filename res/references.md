# Referenser

## Länkar med information

### Allmänt
* http://z80.info/
    sida om z80 processorn; z80 arch, data sheets, instr set mm.
* http://z80-heaven.wikidot.com/
    sida för ti84 asm-programmering; z80/ti asm info
* http://jgmalcolm.com/z80/
    innehåller info från asm-programmeringssidan

### Arkitektur
* http://rabieramadan.org/Microprocessor/lectures/Lecture%203/Chapter%203%20Z80.pdf
    register, struktur, fetch cycle

### Instruktioner
* https://www.csh.rit.edu/~jerry/arcade/pacman/
    pacman arcade maskin, info om odokumenterade instruktioner

### ALU
* http://www.righto.com/2013/09/the-z-80-has-4-bit-alu-heres-how-it.html
    hur z80:ns alu fungerar

### TI/TI84
* https://www.cemetech.net/projects/item.php?id=42#s2
    overview över hur en emulator byggt moduler kring z80
* http://wikiti.brandonw.net/index.php?title=Calculator_Documentation#TI-83_Plus_Family
    hårdvaruspec och dylikt

## Källkod/program att granska/använda

### Emulatorer
* https://github.com/KnightOS/z80e
    emulator för KnightOS dev - för ti84, C. 
    * libz80e/src/ti/asic.c innehåller kod för TI-specifik kontroller (portarna
      och det).
* https://github.com/begoon/yaze
    yet another z80 emulator, C
* http://lpg.ticalc.org/prj_tilem/develop.html
    ti84 emulator, C. 
    * emu/z80cmds.h **innehåller C-macros för varenda z80 instruktion
      (tilldelning av register och flaggor)**

### Assemblers
* https://github.com/KnightOS/scas
    assembler/linker byggd för KnightOS, C
* http://k1.spdns.de/Git/zasm-4.0.git/tree/
    assembler, c++
* https://www.tablix.org/~avian/blog/articles/z80dasm/
    z80 binary disassembler, C

### Annat
* https://github.com/KnightOS
    OS för z80 miniräknare under utveckling, har massa olika program