incsrc "defines.asm"

incsrc "edits.asm"
incsrc "hijacks.asm"

%org($0F, $E34C)
incsrc "nmi.asm"
incsrc "every_frame.asm"
incsrc "level.asm"

print site
warnsite $E516

; title screen digits
org $020310
incbin "chr/numbers.bin"
