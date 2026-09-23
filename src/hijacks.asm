

%org($0F, $F9D1)
		jmp nmi_exit

%org($0F, $FC31)
		jsr every_frame
		nop
		
%org($0E, $D06E)
		jsr $D0D1
		jsr $D34D
		;jsr $D34D
		lda #$88
		sta $A1
		jsr $FD69
		jsr $FDED
		lda #$E8
		sta $10
		lda #$D0
		sta $11
		lda #$01
		jsr $FC65
		lda #$15
		sta $10
		lda #$CC
		sta $11
		lda #$02
		jsr $FC65
		jsr $D12E
		lda #$00
		sta $22
		lda #$01
		sta $15
		lda #$18
		jsr $FCD1
		jsr $FCD7
		jsr level_init
		
%org($0E, $D0CE)
		jmp level_tick
		
%org($0F, $E16D)
		jsr item_interaction
		
%org($0F, $E1D8)
		jsr locked_door
		
%org($0E, $D85A)
		jsr transformation
		
%org($0E, $CC0F)
		jmp increment_level

%org($0E, $D330)
		jsr pause_init
		
%org($0E, $D335)
		jsr pause_tick
		
; top exit
%org($0E, $CC86)
		jsr fade_out_start
		
; bottom exit
%org($0E, $CCAD)
		jsr fade_out_start
		
; mid screen exit
%org($0E, $CCDE)
		jsr fade_out_start
		
; side exit
%org($0E, $CD1D)
		jsr fade_out_start

