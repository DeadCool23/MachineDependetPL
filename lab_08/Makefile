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

CPP_SRC = $(wildcard $(SRC_DIR)/*.cpp)
NASM_SRC = $(wildcard $(SRC_DIR)/*.asm)

CPP_OBJ = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRC))
NASM_OBJ = $(patsubst $(SRC_DIR)/%.asm, $(OBJ_DIR)/%.o, $(NASM_SRC))

all: clean build

build: $(TARGET)

mno-build:
	$(RM) -r $(OBJ_DIR)
	$(MAKE) $(MNO_TARGET)

m-build:
	$(RM) -r $(OBJ_DIR)
	$(MAKE) $(M_TARGET)

debug: CPPFLAGS += -g
debug: $(TARGET)

clean:
	rm -f $(TARGET) $(M_TARGET) $(MNO_TARGET) -r $(OBJ_DIR)

$(TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPP_OBJ) $(NASM_OBJ) -no-pie -o $@

$(M_TARGET): CPPFLAGS += -m80387
$(M_TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPP_OBJ) $(NASM_OBJ) -no-pie -o $@

$(MNO_TARGET): CPPFLAGS += -mno-80387
$(MNO_TARGET): $(OBJ_DIR) $(CPP_OBJ) $(NASM_OBJ)
	$(CC) $(CPP_OBJ) $(NASM_OBJ) -no-pie -o $@

$(OBJ_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CPPFLAGS) $(INC) -c $< -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.asm
	$(ASM_CC) -f $(NASM_FORMAT) $< -o $@
