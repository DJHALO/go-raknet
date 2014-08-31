RAKNET := $(dir $(lastword $(MAKEFILE_LIST)))
RAKNET_SOURCE_DIR := $(RAKNET)Source
RAKNET_LIB_DIR := $(shell cd `go env GOPATH` && echo `pwd`)/pkg/windows_386/github.com/DJHALO
RAKNET_SAMPLE_DIR := $(RAKNET)Samples

CXX = gcc
SHELL := /bin/bash

# library
RAKNET_LIB = $(RAKNET_LIB_DIR)/go-raknet.a
RAKNET_SOURCE := $(RAKNET_SOURCE_DIR)/Base64Encoder.cpp \
				$(RAKNET_SOURCE_DIR)/BitStream.cpp \
				$(RAKNET_SOURCE_DIR)/CCRakNetSlidingWindow.cpp \
				$(RAKNET_SOURCE_DIR)/CloudClient.cpp \
				$(RAKNET_SOURCE_DIR)/CloudCommon.cpp \
				$(RAKNET_SOURCE_DIR)/CloudServer.cpp \
				$(RAKNET_SOURCE_DIR)/ConnectionGraph2.cpp \
				$(RAKNET_SOURCE_DIR)/DR_SHA1.cpp \
				$(RAKNET_SOURCE_DIR)/DS_HuffmanEncodingTree.cpp \
				$(RAKNET_SOURCE_DIR)/DS_ByteQueue.cpp \
				$(RAKNET_SOURCE_DIR)/DynDNS.cpp \
				$(RAKNET_SOURCE_DIR)/FullyConnectedMesh2.cpp \
				$(RAKNET_SOURCE_DIR)/Gets.cpp \
				$(RAKNET_SOURCE_DIR)/GetTime.cpp \
				$(RAKNET_SOURCE_DIR)/Itoa.cpp \
				$(RAKNET_SOURCE_DIR)/LocklessTypes.cpp \
				$(RAKNET_SOURCE_DIR)/NatPunchthroughServer.cpp \
				$(RAKNET_SOURCE_DIR)/NatTypeDetectionCommon.cpp \
				$(RAKNET_SOURCE_DIR)/NatTypeDetectionServer.cpp \
				$(RAKNET_SOURCE_DIR)/PluginInterface2.cpp \
				$(RAKNET_SOURCE_DIR)/Rand.cpp \
				$(RAKNET_SOURCE_DIR)/RakMemoryOverride.cpp \
				$(RAKNET_SOURCE_DIR)/RakNetSocket2.cpp \
				$(RAKNET_SOURCE_DIR)/RakNetTypes.cpp \
				$(RAKNET_SOURCE_DIR)/RakPeer.cpp \
				$(RAKNET_SOURCE_DIR)/RakSleep.cpp \
				$(RAKNET_SOURCE_DIR)/RakNetStatistics.cpp \
				$(RAKNET_SOURCE_DIR)/RakString.cpp \
				$(RAKNET_SOURCE_DIR)/RakThread.cpp \
				$(RAKNET_SOURCE_DIR)/RelayPlugin.cpp \
				$(RAKNET_SOURCE_DIR)/ReliabilityLayer.cpp \
				$(RAKNET_SOURCE_DIR)/SignaledEvent.cpp \
				$(RAKNET_SOURCE_DIR)/SimpleMutex.cpp \
				$(RAKNET_SOURCE_DIR)/SocketLayer.cpp \
				$(RAKNET_SOURCE_DIR)/StringCompressor.cpp \
				$(RAKNET_SOURCE_DIR)/StringTable.cpp \
				$(RAKNET_SOURCE_DIR)/SuperFastHash.cpp \
				$(RAKNET_SOURCE_DIR)/TCPInterface.cpp \
				$(RAKNET_SOURCE_DIR)/TwoWayAuthentication.cpp \
				$(RAKNET_SOURCE_DIR)/UDPProxyCoordinator.cpp \
				$(RAKNET_SOURCE_DIR)/UDPForwarder.cpp \
				$(RAKNET_SOURCE_DIR)/UDPProxyServer.cpp \
				$(RAKNET_SOURCE_DIR)/WSAStartupSingleton.cpp \
				$(RAKNET_SOURCE_DIR)/raknet_wrap.cpp

RAKNET_OBJ = $(RAKNET_SOURCE:.cpp=.o)

SWIG_SOURCE_GO := raknet.go
SWIG_SOURCE_C := raknet_gc.c
SWIG_OBJ := $(SWIG_SOURCE_GO:.go=.8) $(SWIG_SOURCE_C:.c=.8)

GOPACK := go tool pack
GOC := go tool 8c
GOG := go tool 8g
GOL := go tool 8l

LDFLAGS += -lpthread -lraknet -LLib -L/mingw/lib
CXXFLAGS += -I$(RAKNET_SOURCE_DIR) -I$(RAKNET_SAMPLE_DIR)/CloudServer -Wall -DSHA1_HAS_TCHAR -fPIC

ifeq ($(OS),Windows_NT)
	CXXFLAGS += -D_WIN32 -D_WIN32_WINNT=0x501
	LDFLAGS += -lwsock32 -lws2_32
endif

all: lib
lib: $(SWIG_SOURCE_GO) $(RAKNET_LIB)

$(RAKNET_LIB): $(RAKNET_OBJ) $(SWIG_OBJ) $(RAKNET_LIB_DIR)
	$(GOPACK) grc $@ $(RAKNET_OBJ) $(SWIG_OBJ)

$(RAKNET_LIB_DIR):
	mkdir -p $(RAKNET_LIB_DIR)

$(SWIG_SOURCE_GO):
	swig -go -c++ -v -o Source/raknet_wrap.cpp -outdir . -intgosize 32 swig-interface/raknet.i

%.8: %.go
	$(GOG) $^

%.8: %.c
	$(GOC) -I $(shell cd `go env GOROOT` && echo `pwd`)/src/pkg/runtime $^

clean:
	rm -rf $(RAKNET_OBJ) $(RAKNET_LIB) $(SWIG_OBJ) $(SWIG_SOURCE_C) $(SWIG_SOURCE_GO) Source/raknet_wrap.cpp
