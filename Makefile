SOURCES = dcpu.asm display.asm
OBJS	= $(SOURCES:.asm=.o)

SOURCES_C = compile.asm
OBJS_C	= $(SOURCES_C:.asm=.o)

all: dcpu compile

dcpu: $(OBJS)
	mkdir -p bin
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc -lpthread -lX11 -lXext -o bin/$@ $(patsubst %, obj/%, $(OBJS))
	
compile: $(OBJS_C)
	mkdir -p bin
	ld -m elf_i386 -dynamic-linker /lib/ld-linux.so.2 -lc -o bin/$@ $(patsubst %, obj/%, $(OBJS_C))

VPATH = src/

%.o : %.asm
	mkdir -p obj
	yasm -f elf32 -g dwarf2 -o obj/$@ $<
