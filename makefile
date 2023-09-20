# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++11 -g -Wall -Wextra

# FlatBuffers compiler
FLATC = flatc

# Directories
SOURCE_DIR = src
GENERATED_DIR = generated

# Generated files
CPP_SOURCES = $(GENERATED_DIR)/client_generated.h 
PY_SOURCES = $(GENERATED_DIR)/client_generated.py

# Target for generating C++ and Python code from the schema
all: generate_cpp generate_python compile_cpp

generate_cpp: $(CPP_SOURCES)

generate_python: $(PY_SOURCES)

# Target for compiling the C++ code
compile_cpp: $(SOURCE_DIR)/encode_data.cpp $(CPP_SOURCES)
	$(CXX) $(CXXFLAGS) -o fb_encoder $^



# Clean generated files and compiled programs
clean:
	rm -f $(CPP_SOURCES) $(PY_SOURCES) fb_encoder


$(GENERATED_DIR)/client_generated.h: $(SOURCE_DIR)/client.fbs
	@echo "Generating C++ code from $(SOURCE_DIR).fbs..."
	$(FLATC) --cpp -o $(GENERATED_DIR) $(SOURCE_DIR)/client.fbs
	@echo "C++ code generated in $(GENERATED_DIR)"

$(GENERATED_DIR)/client_generated.py: $(SOURCE_DIR)/client.fbs
	@echo "Generating Python code from $(SOURCE_DIR).fbs..."
	$(FLATC) --python -o $(GENERATED_DIR) $(SOURCE_DIR)/client.fbs
	@echo "Python code generated in $(GENERATED_DIR)"

.PHONY: flatc compile_cpp clean

