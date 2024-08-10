CC := nasm
LD := ld

CC_ARGS := -f elf64
LD_FLAGS :=

SRC := gcd.asm
OBJ := gcd.o
OUT := gcd

all: $(OUT)

$(SRC):
	touch $(SRC)

$(OBJ): $(SRC)
	$(CC) $(CC_ARGS) -o $@ $<

$(OUT): $(OBJ)
	$(LD) $(LD_FLAGS) -o $@ $<

run: $(OUT)
	./$(OUT)

clean:
	rm -f $(OBJ) $(OUT)

c: atoi.c
	gcc atoi.c -o atoi -Wall -pedantic -ggdb
