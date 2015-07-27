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
JAVA_DIR := YCSB/ramcloud/src/main/java/com/yahoo/ycsb/db

all: helper $(JAVA_DIR)/RamCloudClient.class
helper: helper.cc $(RAMCLOUD_DIR)/bin/libramcloud.so
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(LIBS) helper.cc -o helper -Wl,-rpath=$(BIN_DIR)

CP := $(RAMCLOUD_DIR)/bin/java:YCSB/core/target/core-0.1.4.jar

$(JAVA_DIR)/RamCloudClient.class: $(JAVA_DIR)/RamCloudClient.java
	javac -cp $(CP) $(JAVA_DIR)/RamCloudClient.java