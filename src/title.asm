; move the cursor down
%org($0E, $C9AF)
		lda #$BF
%org($0E, $C9C3)
		lda #$BF
		
; skip "continue" cover up, always enable level select and show the level number on screen
%org($0E, $C9D7)
title_screen:
		lda #0
		sta current_level
		inc reset_timers

	; draw "dream" text
		ldx vram_buffer_index
		ldy #$00
	-	lda dream_select_text,y
		sta vram_buffer,x
		inx
		iny
		cpy #$0F
		bne -
		stx vram_buffer_index

	; title screen loop with "dream select" handler
	.loop
		lda #$01				
		jsr $FC81
		
		lda $23
		bne .loop
		
		lda $29
		cmp #$08
		bne +
		jmp $CA88				; start the game
	+
		
		cmp #$01
		bne .loop
		
		ldy current_level
		cpy #$09				; allow selecting 8-2 and 8-3
		bcc +					; and allow cycling back to 0
		ldy #$FF
		clc
	+	iny
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
		tya
		adc #$31
		sta vram_buffer,x
		inx
		stx vram_buffer_index
		
		lda #$21
		jsr $FD52
		jmp .loop

bank0E_to_CA87:
warnsite $CA87

%org($0E, $CAE6)
dream_select_text:
		db $0C, $23, $0C
		; DREAM 1
		db $FE, $52, $45, $41, $4D, $00, $31, $00, $00, $00, $00, $00

; title screen tilemap
%org($0D, $9CEC)
		db "PRACTICE", $00, "!VERSION"
