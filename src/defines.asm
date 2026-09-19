macro org(bank, offset)
    org $10 + ({offset}&$1FFF) + ($2000*{bank})
    site {offset}
	print pc
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


; ram
nmi_flag				= $12
