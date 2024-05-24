CC = g++ 
CPPFLAGS = 
INC = -I inc

TARGET = app.exe

OBJ_DIR = out
SRC_DIR = src

CPP_SRC = $(wildcard $(SRC_DIR)/*.cpp)
CPP_OBJ = $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(CPP_SRC))

.PHONY: all
all: clean build

.PHONY: build
build: $(TARGET)

.PHONY: debug
debug: CPPFLAGS += -g
debug: $(TARGET)

.PHONY: clean
clean:
	rm -f $(TARGET) -r $(OBJ_DIR)

$(TARGET): $(OBJ_DIR) $(CPP_OBJ)
	$(CC) $(CPPFLAGS) $(CPP_OBJ) $(INC) -o $@

$(OBJ_DIR):
	mkdir -p $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) $(CPPFLAGS) $(INC) -c $< -o $@
