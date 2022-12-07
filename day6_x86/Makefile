.PHONY: all
all: solve_a solve_b

solve_%: solve_%.o
	ld -o $@ $<

%.o: %.nasm
	nasm -f elf64 $<

clean:
	rm -f *.o solve_*
