ZIG = zig
ZIGFLAGS = --target-os freestanding --target-arch i386
LINKSCRIPT = linker.ld

IN = main.zig
OUT = zignix

.PHONY: all clean run

all: $(OUT)

clean:
	rm -f $(OUT)

$(OUT): $(IN) $(LINKSCRIPT) lib
	$(ZIG) build-exe $(IN) $(ZIGFLAGS) --linker-script $(LINKSCRIPT) --output $(OUT)

run: $(OUT)
	qemu-system-i386 -kernel $(OUT)
