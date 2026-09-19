

%org($0F, $F9D1)
		jmp nmi_exit

%org($0F, $FC31)
		jsr every_frame
		nop
		