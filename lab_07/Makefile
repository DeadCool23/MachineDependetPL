CC = g++ 
ASM_CC = nasm
CPPFLAGS = -masm=intel
INC = -I inc

TARGET = app.exe
ifeq ($(OS), Windows_NT)
	NASM_FORMAT = win64
else
	UNAME_S = $(shell uname -s)
	ifeq ($(UNAME_S), Linux)
		NASM_FORMAT = elf64
	else ifeq ($(UNAME_S), Darwin)
		NASM_FORMAT = macho64
	endif
endif

OBJ_DIR = out
SRC_DIR = src

CPP_SRC = $(wildcard $(SRC_DIR)/*.cpp)
NASM_SRC = $(wildcard $(SRC_DIR)/*.asm)

CPP_OBJ = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRC))
NASM_OBJ = $(patsubst $(SRC_DIR)/%.asm, $(OBJ_DIR)/%.o, $(NASM_SRC))

all: clean build

build: $(TARGET)

debug: CPPFLAGS += -g
debug: $(TARGET)

clean:
	rm -f $(TARGET) -r $(OBJ_DIR)

$(TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPPFLAGS) $(CPP_OBJ) $(NASM_OBJ) $(INC) -no-pie -o $@

$(OBJ_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CPPFLAGS) $(INC) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM_CC) -f $(NASM_FORMAT) $< -o $@
