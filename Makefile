AS := futaba.exe
AFLAGS := --no-retry

all: j

j:
	$(AS) build $(AFLAGS) nemo_j.futaba

.PHONY: all, clean
clean:
	rm -f target/*.nes
