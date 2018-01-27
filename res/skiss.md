# skiss

## arkitektur
  * Pipelining
    mittemellen OR och pipeline; fetch:ar medans exec. borde vara 1 cp fetch
    och 1 cp exec som på föreläsningen om pipelines.

  * Bussar
    har 16 "tri-state"(?) addressbuss. Skickar addresser till
    register och I/O. Har en 8 tri-state databuss som går mellan minne
    processor, IO mm.

  * Interrupts
    har en interrupt vector som m68k hade, med varierande nivåer

  * statusregister/flaggor
    har sign (S), zero (Z), half carry (H), parity/overflow (P/V), add/subtract
    (N), carry (C).

## instruktioner
  * längd varierar mellan 1 till 4 bytes.
  * har typ 256 st, men många liknade

## ti84
