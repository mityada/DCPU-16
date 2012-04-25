SOURCES = dcpu.asm display.asm
OBJS	= $(SOURCES:.asm=.o)

all: dcpu

dcpu: $(OBJS)
	mkdir -p bin
	ld -dynamic-linker /lib/ld-linux.so.2 -lc -lX11 -o bin/$@ $(patsubst %, obj/%, $(OBJS))

VPATH = src/

%.o : %.asm
	mkdir -p obj
	yasm -f elf32 -g dwarf2 -o obj/$@ $<
