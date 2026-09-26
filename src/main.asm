incsrc "defines.asm"

incsrc "edits.asm"
incsrc "title.asm"
incsrc "hijacks.asm"

%org($0F, $E34C)
incsrc "nmi.asm"
incsrc "every_frame.asm"
incsrc "level.asm"

printf "bank 0F space: {0}/00E510", site
warnsite $E510

; title screen graphics
org $0202F0
incbin "chr/period.bin"
org $020310
incbin "chr/numbers.bin"
