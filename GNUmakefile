# This Makefile builds the Client application that's needed for
# managing YCSB runs

# Normally there should be a symbolic link "ramcloud" in this directory,
# which refers to the top-level RAMCloud install directory (i.e., a
# directory containing bin, include, and lib subdirectories)
RAMCLOUD_DIR := ./ramcloud
LIB_DIR := $(RAMCLOUD_DIR)/lib/ramcloud

INCLUDES := -I$(RAMCLOUD_DIR)/include -I.
CXXFLAGS := --std=c++0x -g -DNDEBUG
CXX ?= g++
LIBS := -L$(RAMCLOUD_DIR)/lib/ramcloud -lramcloud
JAVA_DIR := YCSB/ramcloud/src/main/java/com/yahoo/ycsb/db

all: helper $(JAVA_DIR)/RamCloudClient.class
helper: helper.cc $(LIB_DIR)/libramcloud.so
	$(CXX) $(CXXFLAGS) $(INCLUDES) helper.cc -o helper $(LIBS) -Wl,-rpath=$(LIB_DIR)

CP := $(RAMCLOUD_DIR)/lib/ramcloud/ramcloud.jar:YCSB/core/target/core-0.1.4.jar

$(JAVA_DIR)/RamCloudClient.class: $(JAVA_DIR)/RamCloudClient.java
	javac -cp $(CP) $(JAVA_DIR)/RamCloudClient.java
