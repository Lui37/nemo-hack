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

; skip level end cutscenes
%org($0E, $CBFE)
		bcc $CC0D

; skip level intro cutscenes
%org($0E, $CD87)
		jmp $CD90
		
; move the title screen cursor down
%org($0E, $C9AF)
		lda #$BF
%org($0E, $C9C3)
		lda #$BF
	

