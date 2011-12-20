VERSION := 1.0.4

ifeq ($(shell uname -sm | sed -e s,x86_64,i386,),Darwin i386)
export CC=gcc -arch i386
export LUA_DIR=$(LUVIT_DIR)/deps/luajit/src
export LDFLAGS_EXTRA=-shared $(LUA_DIR)/libluajit.a
endif

LUVIT_DIR?=

all: json

json: build/lua-cjson/cjson.so
	mkdir -p modules/cjson
	cp build/lua-cjson/cjson.so modules/cjson/cjson.luvit

build/lua-cjson/cjson.so: build/lua-cjson
	${MAKE} -C $^ LDFLAGS_EXTRA="${LDFLAGS_EXTRA}" LUA_INCLUDE_DIR=$(LUA_DIR)

build/lua-cjson:
	mkdir -p build
	wget -v http://www.kyne.com.au/~mark/software/lua-cjson-$(VERSION).tar.gz -O - | tar -xzpf - -C build
	mv build/lua-cjson-* $@

clean:
	rm -rf build/lua-cjson/cjson.so build/lua-cjson/*.o
	rm -f modules/cjson/cjson.luvit

mrproper:
	rm -rf build

at=
install:
ifeq ($(at),)
	@echo Use: ${MAKE} install at=/
	@false
else
	mkdir -p $(at)/cjson
	cp cjson.luvit init.lua $(at)/cjson/
endif

.PHONY: all json clean mrproper install
