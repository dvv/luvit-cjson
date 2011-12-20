#!/usr/bin/env luvit

local JSON = require('cjson')
assert(not _G.json)
assert(JSON.encode)
assert(JSON.decode)

local obj, serialized, content

obj = { 1, 2, 3, 4 }
p(obj)
serialized = JSON.encode(obj)
p(serialized)
content = JSON.decode(serialized)
p(content)
assert(obj[2] == content[2])

obj = { a = {'foo', true, false} }
p(obj)
serialized = JSON.encode(obj)
p(serialized)
content = JSON.decode(serialized)
p(content)
assert(obj.a[3] == content.a[3])
