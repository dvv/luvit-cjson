VERSION := 1.0.4

ROOT    := $(shell pwd)
PATH    := $(ROOT)/.luvit:$(PATH)

all: module

test: module
	./test

module: build/cjson/cjson.luvit

OS ?= $(shell uname)
ifeq ($(OS),Darwin)
SOEXT := dylib
else ifeq ($(OS),Windows)
SOEXT := dll
else
SOEXT := so
endif

build/cjson/cjson.luvit: build/cjson
	CFLAGS=`luvit-config --cflags` make -C $^
	mv build/cjson/cjson.$(SOEXT) $@

build/cjson:
	mkdir -p build
	wget -qct3 --progress=bar http://www.kyne.com.au/~mark/software/lua-cjson-$(VERSION).tar.gz -O - | tar -xzpf - -C build
	mv build/lua-cjson-* $@

clean:
	rm -fr build

.PHONY: all module clean
.SILENT:
