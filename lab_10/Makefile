CC = gcc
ASM_CC = nasm
CFLAGS = -L/usr/lib/x86_64-linux-gnu $$(pkg-config --cflags --libs gtk+-3.0) -no-pie
INC = -I inc

ifeq ($(OS), Windows_NT)
	$(error This Makefile does not support Windows)
endif

UNAME_S = $(shell uname -s)
ifeq ($(UNAME_S), Linux)
	NASM_FORMAT = elf64
else ifeq ($(UNAME_S), Darwin)
	$(error This Makefile does not support MacOS)
endif

TARGET = app.exe

OBJ_DIR = out
SRC_DIR = src

NASM_SRC = $(wildcard $(SRC_DIR)/*.asm)
NASM_OBJ = $(patsubst $(SRC_DIR)/%.asm, $(OBJ_DIR)/%.o, $(NASM_SRC))

.PHONY: all
all: clean build

.PHONY: build
build: $(TARGET)

.PHONY: debug
debug: CFLAGS += -g
debug: $(TARGET)

.PHONY: clean
clean:
	rm -f $(TARGET) -r $(OBJ_DIR)

$(TARGET): $(OBJ_DIR) $(NASM_OBJ)
	$(CC) $(NASM_OBJ) $(CFLAGS) -o $@

$(OBJ_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM_CC) -f $(NASM_FORMAT) $< -o $@