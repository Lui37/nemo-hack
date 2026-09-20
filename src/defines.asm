!VERSION = "V0/1"

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
BOSS_HP_LOCATION		= $2B35

; ram
nmi_flag				= $13
vram_buffer_index		= $77
current_keys			= $8B
current_lives			= $8D
current_level			= $96
animal_action_timer		= $9A
vram_buffer				= $0300
object_x_pos_hi			= $04C0
object_x_pos_lo			= $04D0
object_x_subpixel		= $04E0
object_y_pos_hi			= $04F0
object_y_pos_lo			= $0500
object_y_subpixel		= $0510
object_x_speed_hi		= $0520
object_x_speed_lo		= $0530
object_y_speed_hi		= $0540
object_y_speed_lo		= $0550
object_pose				= $05C0
object_id				= $0490
object_hp				= $05D0
object_timer			= $0620
input_rlduteba_hold		= $0690
input_rlduteba_frame	= $0692
