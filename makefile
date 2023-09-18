# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++11 -Wall -Wextra

# FlatBuffers compiler
FLATC = flatc

# Directories
SOURCE_DIR = src
GENERATED_DIR = generated

# Generated files
CPP_SOURCES = $(GENERATED_DIR)/client_generated.h $(GENERATED_DIR)/client_generated.cpp
PY_SOURCES = $(GENERATED_DIR)/client_generated.py

# Target for generating C++ and Python code from the schema
flatc: $(CPP_SOURCES) $(PY_SOURCES)

# Target for compiling the C++ code
compile_cpp: $(SOURCE_DIR)/encode_data.cpp $(CPP_SOURCES)
	$(CXX) $(CXXFLAGS) -o fb_encoder $^

# Clean generated files and compiled programs
clean:
	rm -f $(CPP_SOURCES) $(PY_SOURCES) fb_encoder

# Rule to generate C++ and Python code from the schema
$(GENERATED_DIR)/%_generated.h $(GENERATED_DIR)/%_generated.cpp $(GENERATED_DIR)/%_generated.py: $(SOURCE_DIR)/%.fbs
	$(FLATC) -c -o $(GENERATED_DIR) $<

.PHONY: flatc compile_cpp clean

