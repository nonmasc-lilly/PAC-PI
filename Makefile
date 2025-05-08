ifeq ($(origin LD), default)
LD = gcc
endif
ifeq ($(origin CC), default)
CC = gcc
endif
LFLAGS =
CFLAGS = -c -std=c99 -g

all: build/PAC-PI build/C-PAC-PI

build/PAC-PI: src/main.asm | build
	fasm $< $@

build/C-PAC-PI: build/c-main.o | build
	$(LD) $(LFLAGS) $^ -o $@

build/c-main.o: src/C/main.c | build
	$(CC) $(CFLAGS) $< -o $@

build:
	mkdir -p build/

test: all FORCE
	fasmg test/not.pacpi.asm build/not.pacpi
	build/PAC-PI build/not.pacpi
	build/C-PAC-PI build/not.pacpi


FORCE:
