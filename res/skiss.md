# skiss

## arkitektur
  * Pipelining:
    mittemellen OR och pipeline; fetch:ar medans exec. borde vara 1 cp fetch
    och 1 cp exec som på föreläsningen om pipelines.

  * Bussar:
    har 16 "tri-state"(?) addressbuss. Skickar addresser till
    register och I/O. Har en 8 tri-state databuss som går mellan minne
    processor, IO mm.

  * Interrupts:
    har en interrupt vector som m68k hade, med varierande nivåer

  * Statusregister/flaggor:
    har sign (S), zero (Z), half carry (H), parity/overflow (P/V), add/subtract
    (N), carry (C).

## instruktioner
  * längd varierar mellan 1 till 4 bytes.
  * har åtminstone 256 st, men många liknade (1 byte ger 2^8=256 + de andra)

## ti84
  * upplösning: 96x64 3:2 ratio (~800 bytes videominne om en bit per pixel)
  * 1 MB flash ROM, 480 user accessible (krävs för program)
  * 6 eller 15 MHz

## VGA-skärm
  * upplösning: 640x480 @ 60Hz 4:3 ratio.
    behöver 25Mhz pixelklocka (går det ändra upplösning?)
