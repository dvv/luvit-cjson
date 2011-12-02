ROOT=$(shell pwd)

all: json

json: build/lua-cjson/cjson.so

build/lua-cjson/cjson.so: build/lua-cjson
	LUA_INCLUDE_DIR=$(LUA_DIR) make -C $^

build/lua-cjson:
	mkdir -p build
	wget http://www.kyne.com.au/~mark/software/lua-cjson-1.0.4.tar.gz -O - | tar -xzpf - -C build
	mv build/lua-cjson-* $@

.PHONY: all json
.SILENT:
