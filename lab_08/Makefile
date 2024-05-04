CC = g++ 
ASM_CC = nasm
CPPFLAGS = 
INC = -I inc

TARGET = app.exe
M_TARGET = m_app.exe
MNO_TARGET = mno_app.exe
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
DASM_DIR = disasm

CPP_SRC = $(wildcard $(SRC_DIR)/*.cpp)
CPP_OBJ = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRC))
DASM_FILES = $(patsubst $(SRC_DIR)/%.cpp, $(DASM_DIR)/%.S, $(CPP_SRC))

.PHONY: all
all: clean build dis_asm

.PHONY: build
build: $(TARGET)

.PHONY: mno-build
mno-build:
	$(RM) -r $(OBJ_DIR)
	$(MAKE) $(MNO_TARGET)

.PHONY: m-build
m-build:
	$(RM) -r $(OBJ_DIR)
	$(MAKE) $(M_TARGET)

.PHONY: debug
debug: CPPFLAGS += -g
debug: $(TARGET)

.PHONY: dis_asm
dis_asm: $(DASM_DIR) $(DASM_FILES)

.PHONY: clean
clean:
	rm -f $(TARGET) $(M_TARGET) $(MNO_TARGET) -r $(OBJ_DIR) $(DASM_DIR)

$(TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPPFLAGS) $(CPP_OBJ) $(NASM_OBJ) $(INC) -no-pie -o $@

$(M_TARGET): CPPFLAGS += -m80387
$(M_TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPPFLAGS) $(CPP_OBJ) $(NASM_OBJ) $(INC) -no-pie -o $@

$(MNO_TARGET): CPPFLAGS += -mno-80387
$(MNO_TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPPFLAGS) $(CPP_OBJ) $(NASM_OBJ) $(INC) -no-pie -o $@

$(OBJ_DIR):
	mkdir -p $@

$(DASM_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CPPFLAGS) $(INC) -c $< -o $@

$(DASM_DIR)/%.S: $(SRC_DIR)/%.cpp
	$(CC) $(CPPFLAGS) $(INC) -S $< -o $@
