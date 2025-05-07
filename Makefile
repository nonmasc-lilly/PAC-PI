
all: build/PAC-PI

build/PAC-PI: src/main.asm | build
	fasm $< $@

build:
	mkdir -p build/

test: all FORCE
	fasmg test/not.pacpi.asm build/not.pacpi
	build/PAC-PI build/not.pacpi

FORCE:
