
level_init:
		lda reset_timer
		beq +
		lda counter_60hz
		sta previous_60hz
		lda #0
		sta level_timer_frames
		sta level_timer_seconds
		sta level_timer_minutes
		sta real_frames_elapsed
		sta dropped_frames
		sta reset_timer
	+	jmp handle_timer_drawing


level_tick:
		jsr update_timer
		
		lda draw_timer
		beq +
		jsr handle_timer_drawing
	+
	
		lda current_level
		cmp #7
		bcc +
		jsr handle_boss_hp_drawing
	+
	
		jmp $D0AE
		
update_timer:
	.tick_level_timer
		lda level_timer_frames
		clc
		adc real_frames_elapsed
		sta level_timer_frames
		cmp #60
		bcc ..done
	..tick_seconds
		sbc #60
		sta level_timer_frames
		lda level_timer_seconds
		adc #0
		sta level_timer_seconds
		cmp #60
		bcc ..check_if_done
		
		sbc #60
		sta level_timer_seconds
		lda level_timer_minutes
		adc #0
		cmp #10
		bcc ..no_cap
		lda #59
		sta level_timer_frames
		sta level_timer_seconds
		lda #9
	..no_cap
		sta level_timer_minutes
		
	..check_if_done
		lda level_timer_frames
		cmp #60
		bcs ..tick_seconds
	
	..done
		lda #0
		sta real_frames_elapsed
		rts


handle_timer_drawing:
		ldx vram_buffer_index
		lda #7
		sta vram_buffer,x
		inx
		lda #>TIMER_LOCATION
		sta vram_buffer,x
		inx
		lda #<TIMER_LOCATION
		sta vram_buffer,x
		inx
		
		lda level_timer_minutes
		ora #$30
		sta vram_buffer,x
		inx
		lda level_timer_seconds
		jsr draw_dec_value_with_separator
		lda level_timer_frames
		jsr draw_dec_value_with_separator
		
		stx vram_buffer_index
		
		lda #0
		sta draw_timer
		rts


draw_dec_value_with_separator:
		tay
		lda #$3A
		sta vram_buffer,x
		inx
		tya
draw_dec_value:
	; inline hex to dec
		ldy #0
	-	cmp #10
		bcc +
		sbc #10
		iny
		bcs -
	+	pha
		tya
		ora #$30
		sta vram_buffer,x
		inx
		pla
		ora #$30
		sta vram_buffer,x
		inx
		rts


handle_boss_hp_drawing:
		ldy #2
		lda object_id,y
		cmp #$3F				; penguin
		beq .boss
		cmp #$42				; stingray
		beq .boss
		cmp #$53				; boss defeated
		beq .win
		iny						; use Y=3 for final boss
		cmp #$54				; nightmare king defeated
		beq .win
		cmp #$44				; nightmare king (0493 = 45)
		bne .done
	.boss
		lda object_hp,y
		tay
	.draw_hp
		ldx vram_buffer_index
		lda #4
		sta vram_buffer,x
		inx
		lda #>BOSS_HP_LOCATION
		sta vram_buffer,x
		inx
		lda #<BOSS_HP_LOCATION
		sta vram_buffer,x
		inx
		lda #"B"
		sta vram_buffer,x
		inx
		lda #"="
		sta vram_buffer,x
		inx
		tya
		jsr draw_dec_value
		stx vram_buffer_index
	.done
		rts
		
	.win
		lda object_timer,y		; only draw the level timer once
		cmp #$3C
		bne +
		inc draw_timer
	+
		ldy #0					; force HP to 0
		beq .draw_hp
		
		
		
item_interaction:
		inc draw_timer
		lda object_id,x
		rts
		
transformation:
		inc draw_timer
		jmp $FF71
		
increment_level:
		inc reset_timer
		jmp $CD87

pause_init:
		jsr $FD52
		jmp handle_timer_drawing

pause_tick:
		jsr $FC81
		jmp update_timer
		
