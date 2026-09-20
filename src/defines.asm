macro org(bank, offset)
    org $10 + ({offset}&$1FFF) + ($2000*{bank})
    site {offset}
endmacro

macro hex2dec(register)
		ld{register} #0
	{?}loop
		cmp #10
		bcc {?}done
		sbc #10
		in{register}
		bcs {?}loop
	{?}done
endmacro

; new ram
allocate $F0
	counter_60hz :: 1
	previous_60hz :: 1
	real_frames_elapsed :: 1
	dropped_frames :: 1
	
endallocate

allocate $06B0
	level_timer_frames :: 1
	level_timer_seconds :: 1
	level_timer_minutes :: 1
	draw_timer :: 1
	reset_timer :: 1
endallocate

; constants
TIMER_LOCATION			= $2B23

; ram
nmi_flag				= $12
vram_buffer_index		= $77
vram_buffer				= $0300
player_pose				= $05C0
input_rlduteba_hold		= $0690
input_rlduteba_frame	= $0692
