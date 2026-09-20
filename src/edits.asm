; disable NPC cutscenes to free up space
%org($0F, $E25A)
		nop
		nop
		nop
		
; infinite lives
%org($0E, $CB24)
		beq &
		
; always enable level select and show the level number on screen
%org($0E, $CA00)
title_screen:
		lda #$BF		; enable and print "dream select"
		sta $02F8
		sta $02FC
		ldx vram_buffer_index
		ldy #$00
	-	lda dream_select_text,y
		sta vram_buffer,x
		inx
		iny
		cpy #$0F
		bne -
		stx vram_buffer_index

	.loop
		lda #$01		; level select handler
		jsr $FC81
		
		lda $23
		bne .loop
		
		lda $29
		cmp #$08
		beq $CA88
		
		cmp #$01
		bne .loop
		
		ldy current_level
		cpy #$09		; allow selecting 8-2 and 8-3
		beq .loop
		iny
		sty current_level
		
		ldx vram_buffer_index
		lda #1
		sta vram_buffer,x
		inx
		lda #$23
		sta vram_buffer,x
		inx
		lda #$12
		sta vram_buffer,x
		inx
		iny				; print level number +1
		tya
		ora #$30
		sta vram_buffer,x
		inx
		stx vram_buffer_index
		
		lda #$21
		jsr $FD52
		jmp .loop
		
print site
warnsite $CA5F

%org($0E, $CAE6)
dream_select_text:
		db $0C, $23, $0C
		; DREAM 1
		db $FE, $52, $45, $41, $4D, $00, $31, $00, $00, $00, $00, $00

; title screen tilemap
%org($0D, $9CED)
		db "PRACTICE", $00, "!VERSION"
