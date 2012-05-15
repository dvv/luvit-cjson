#!/usr/bin/env luvit

local JSON = require('./')
assert(not _G.json)
assert(JSON.stringify)
assert(JSON.parse)
assert(JSON.null)

local obj, serialized, content

obj = { 1, 2, 3, 4 }
p(obj)
serialized = JSON.stringify(obj)
p(serialized)
content = JSON.parse(serialized)
p(content)
assert(obj[2] == content[2])

obj = { a = {'foo', true, false} }
p(obj)
serialized = JSON.stringify(obj)
p(serialized)
content = JSON.parse(serialized)
p(content)
assert(obj.a[3] == content.a[3])

--[[
-- bad unicode
local lookup = require('fs').readFileSync('tests/lookup.txt')
lookup = JSON.parse(lookup)
p(lookup)
]]
