
level_init:
		lda #0
		ldy reset_timers
		beq +
		ldy counter_60hz
		sty previous_60hz
		sta real_frames_elapsed
		sta level_timer_frames
		sta level_timer_seconds
		sta level_timer_minutes
		sta reset_timers
	+	inc reset_room_timer
		inc draw_room_timer
		rts


level_tick:
		jsr update_timers
		
		lda current_level
		cmp #7
		bcc +
		jsr handle_boss_hp_drawing
	+

		lda draw_timers
		beq +
		jsr handle_all_timer_drawing
		jmp $D0AE
		
	+
		lda draw_room_timer
		beq +
		jsr handle_room_timer_drawing
	+
		jmp $D0AE
		
		
update_timers:
		lda reset_room_timer
		beq .both
		ldx #0
		stx dropped_frames
		stx room_timer_frames
		stx room_timer_seconds
		stx room_timer_minutes	
		stx reset_room_timer
		beq .level

	.both
		ldx #ROOM_TIMER_OFFSET
		jsr update_timer
		
		ldx #0
	.level
		jsr update_timer
		stx real_frames_elapsed
		rts
		
; X: timer offset
update_timer:
	.tick_level_timer
		lda level_timer_frames,x
		clc
		adc real_frames_elapsed
		sta level_timer_frames,x
		cmp #60
		bcc ..done
	..tick_seconds
		sbc #60
		sta level_timer_frames,x
		lda level_timer_seconds,x
		adc #0
		sta level_timer_seconds,x
		cmp #60
		bcc ..check_if_done
		
		sbc #60
		sta level_timer_seconds,x
		lda level_timer_minutes,x
		adc #0
		cmp #10
		bcc ..no_cap
		lda #59
		sta level_timer_frames,x
		sta level_timer_seconds,x
		lda #9
	..no_cap
		sta level_timer_minutes,x
		
	..check_if_done
		lda level_timer_frames,x
		cmp #60
		bcs ..tick_seconds
	
	..done
		rts


handle_all_timer_drawing:
		lda #0
		sta draw_timers
		lda #>LEVEL_TIMER_LOCATION
		sta scratch
		lda #<LEVEL_TIMER_LOCATION
		sta scratch+1
		lda level_timer_frames
		sta scratch+2
		lda level_timer_seconds
		sta scratch+3
		lda level_timer_minutes
		sta scratch+4
		jsr handle_timer_drawing

handle_room_timer_drawing:
		lda #0
		sta draw_room_timer
		lda #>ROOM_TIMER_LOCATION
		sta scratch
		lda #<ROOM_TIMER_LOCATION
		sta scratch+1
		lda room_timer_frames
		sta scratch+2
		lda room_timer_seconds
		sta scratch+3
		lda room_timer_minutes
		sta scratch+4

; scratch+0(2): timer location
; scratch+2(3): timer values
handle_timer_drawing:
		ldx vram_buffer_index
		lda #7
		sta vram_buffer,x
		inx
		lda scratch
		sta vram_buffer,x
		inx
		lda scratch+1
		sta vram_buffer,x
		inx
		
		lda scratch+4
		ora #$30
		sta vram_buffer,x
		inx
		lda scratch+3
		jsr draw_dec_value_with_separator
		lda scratch+2
		jsr draw_dec_value_with_separator
		
		stx vram_buffer_index
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
		lda object_timer,y		; only draw stuff once
		cmp #$3C
		bne .done
		inc draw_timers
		ldy #0					; force HP to 0
		beq .draw_hp

		
pushpc
pushsite
%org($0E, bank0E_to_CA87:site)

item_interaction:
		inc draw_room_timer
		lda object_id,x
		rts
		
		
locked_door:
		beq .start_opening
		pla
		pla
		rts
		
	.start_opening
		txa
		pha
		jsr update_timers
		jsr handle_all_timer_drawing
		pla
		tax
		rts
		
		
transformation:
		inc draw_room_timer
		jmp $FF71
		
		
increment_level:
		inc reset_timers
		jmp $CD87


pause_init:
		jsr $FD52
		jsr update_timers
		jmp handle_room_timer_drawing


pause_tick:
		jsr $FC81
		jmp update_timers
		

fade_out_start:
		jsr handle_room_timer_drawing
		jmp $FCE8
		
printf "bank 0E space: {0}/00CA87", site
warnsite $CA87
		
pullsite
pullpc
