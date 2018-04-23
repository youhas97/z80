# Referenser

## Länkar med information

### Allmänt
* http://z80.info/
    sida om z80 processorn; z80 arch, data sheets, instr set mm.
* http://z80-heaven.wikidot.com/
    sida för ti84 asm-programmering; z80/ti asm info
* http://jgmalcolm.com/z80/
    innehåller info från asm-programmeringssidan
* https://books.google.se/books?id=mVQnFgWzX0AC
    bok om att bygga en egen z80

### Arkitektur
* http://rabieramadan.org/Microprocessor/lectures/Lecture%203/Chapter%203%20Z80.pdf
    register, struktur, fetch cycle
* http://www.z80.info/zaks.html
    bästa bok om allt
* http://www.righto.com/2014/10/how-z80s-registers-are-implemented-down.html
    artikel om register
* https://patents.google.com/patent/US4332008
    patent för z80 struktur

### Instruktioner
* https://www.csh.rit.edu/~jerry/arcade/pacman/
    pacman arcade maskin, info om odokumenterade instruktioner
* http://www.z80.info/decoding.htm
    decoding tree för ops
* instr timings
    * http://www.baltazarstudios.com/files/xx.html
    * http://www.baltazarstudios.com/files/ed.html
    * http://www.baltazarstudios.com/files/cb.html
    * http://www.baltazarstudios.com/files/dd.html
    * http://www.baltazarstudios.com/files/ddcb.html

### ALU
* http://www.righto.com/2013/09/the-z-80-has-4-bit-alu-heres-how-it.html
    hur z80:ns alu fungerar
* https://stackoverflow.com/questions/8034566/overflow-and-carry-flags-on-z80
* diskussion om z80 carry overflow

### IO
* http://wikiti.brandonw.net/?title=Category:83Plus:Ports:By_Address
    beskrivning av alla portar
* http://z80-heaven.wikidot.com/ports
    kort info om varje port
* http://z80-heaven.wikidot.com/direct-input-output
    info om kbd och lcd portar

### Minne
* http://wikiti.brandonw.net/index.php?title=83Plus:Memory_Mapping
    info om pages och modes

### Register
* http://www.righto.com/2014/10/how-z80s-registers-are-implemented-down.html
    hur z80:s register är implementerade

### TI/TI84
* https://www.cemetech.net/projects/item.php?id=42#s2
    overview över hur en emulator byggt moduler kring z80
* http://wikiti.brandonw.net/index.php?title=Calculator_Documentation#TI-83_Plus_Family
    hårdvaruspec och dylikt

## Källkod/program att granska/använda

### Emulatorer
* https://github.com/KnightOS/z80e
    emulator för KnightOS dev - för ti84, C. 
    * src/ti/asic.c innehåller kod för TI-specifik kontroller (portarna
      och det).
    * src/core/cpu.c innehåller en implementation för hela cpu:n. hela
      instructionsdekodaren med exekvering finns på rad 930
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
