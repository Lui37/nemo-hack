; disable NPC cutscenes to free up space
%org($0F, $E25A)
		nop
		nop
		nop
		
; relocate some subroutine that is used by cutscenes
%org($0F, $E510)
subroutine_E4B6:
		inc $7F
		bne +
		inc $80
	+	rts
%org($0F, $E2B6)
		jsr subroutine_E4B6
		jsr subroutine_E4B6
%org($0F, $E2EE)
		jsr subroutine_E4B6
%org($0F, $E2F6)
		jsr subroutine_E4B6
		
; infinite lives
%org($0E, $CB24)
		bvs &
		
; title screen stuff
%org($0E, $C9AF)
		lda #$BF
%org($0E, $C9C3)
		lda #$BF
		
; skip "continue" cover up
%org($0E, $C9D7)
		lda #0
		sta current_level
		jmp title_screen
		
; always enable level select and show the level number on screen
%org($0E, $CA00)
title_screen:
		ldx vram_buffer_index
		ldy #$00
	-	lda dream_select_text,y
		sta vram_buffer,x
		inx
		iny
		cpy #$0F
		bne -
		stx vram_buffer_index

	; title screen with level select handler
	.loop
		lda #$01				
		sta reset_timer			; fix the demo messing up the timer
		jsr $FC81
		
		lda $23
		bne .loop
		
		lda $29
		cmp #$08
		beq $CA88
		
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

; skip level end cutscenes
%org($0E, $CBFE)
		bcc $CC0D

; skip level intro cutscenes
%org($0E, $CD87)
		jmp $CD90

