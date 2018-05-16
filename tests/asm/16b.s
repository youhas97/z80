org 0x9d95

or a
ld hl, 0x1e
ld de, 0x0a
sbc hl, de
jp m, fail
jp z, fail
jp pe, fail
jp c, fail
ld a, h
cp 0x00
jp nz, fail
ld a, l
cp 0x14
jp nz, fail

success:
ld a, 0xcc
halt

fail:
ld a, 0xee
halt