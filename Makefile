ROOT    := $(shell pwd)
PATH    := $(ROOT):$(PATH)

GET := $(shell which curl && echo ' -L --progress-bar')
ifeq ($(GET),)
GET := $(shell which wget && echo ' -qct3 --progress=bar --no-check-certificate -O -')
endif
ifeq ($(GET),)
GET := curl-or-wget-is-missing
endif

all: module

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
	#CFLAGS="`luvit --cflags` -I../luvit/include/luvit" make -C $^
	#mv build/cjson/cjson.$(SOEXT) $@
	$(CC) `luvit --cflags | sed 's/ -Werror / /'` $^/lua_cjson.c $^/strbuf.c $^/fpconv.c -shared $(LDFLAGS) -o $@

build/cjson:
	mkdir -p build
	$(GET) https://github.com/mpx/lua-cjson/tarball/master | tar -xzpf - -C build
	mv build/mpx-lua-cjson-* $@

clean:
	rm -fr build

test: module
	-luvit -e '' || wget -qct3 http://luvit.io/dist/latest/ubuntu-latest/$(shell uname -m)/luvit-bundled/luvit
	-chmod a+x luvit 2>/dev/null
	luvit test.lua

.PHONY: all module clean test
.SILENT:
