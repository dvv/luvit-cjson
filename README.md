JSON for Luvit
=====

[![Build Status](https://secure.travis-ci.org/dvv/luvit-cjson.png)](http://travis-ci.org/dvv/luvit-cjson)

N.B.
-----
Luvit has now native `json` module based on [yajl](https://github.com/lloyd/yajl).

Usage
-----

```lua
// import module
local JSON = require('cjson')

// simple encode/decode loop
local obj, serialized, content
obj = { 1, 2, 3, 4 }
p(obj)
serialized = JSON.stringify(obj)
p(serialized)
content = JSON.parse(serialized)
p(content)
assert(obj[2] == content[2])
```

License
-------

[MIT](dvv/luvit-cjson/license.txt)
