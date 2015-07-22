# This Makefile builds the Client application that's needed for
# managing YCSB runs

# Normally there should be a symbolic link "ramcloud" in this directory,
# which refers to the top-level RAMCloud install directory (i.e., a
# directory containing bin, include, and lib subdirectories)
RAMCLOUD_DIR := ./ramcloud
BIN_DIR := $(RAMCLOUD_DIR)/bin

INCLUDES := -I$(RAMCLOUD_DIR)/include -I.
CXXFLAGS := --std=c++0x -g -DNDEBUG
CXX ?= g++
LIBS := -L$(RAMCLOUD_DIR)/bin -lramcloud

#comment, I added the -Wl,-rpath to tell the linker/loader to look in that dir at execution for libramcloud.so
all: helper
helper: helper.cc $(RAMCLOUD_DIR)/bin/libramcloud.so
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) helper.cc -o helper -Wl,-rpath=$(BIN_DIR)
