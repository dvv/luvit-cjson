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

-- multivalue
p(JSON.parse('[1][2]\n[3]\n', { allow_multiple_values = true }))
p(#JSON.parse(('[1]\n'):rep(40000), { allow_multiple_values = true }))
do
  local results = {}
  local parser = JSON.streamingParser(function(value)
    results[#results + 1] = value
    if #results == 30 then
      print('OK')
    end
  end, { allow_multiple_values = true })
  local status, result = pcall(parser.parse, parser, ('[2]\n'):rep(30))
  p(status, result, #results)
  --assert(status)
  --assert(#result == 10000)
end

-- streaming
do
  local results = {}
  local parser = JSON.streamingParser(function(value)
    p('VALUE:', value)
  end, { allow_multiple_values = true })
  parser:parse('[1')
  parser:parse(']\n[2]\n[')
end

--[[
-- bad unicode
local lookup = require('fs').readFileSync('tests/lookup.txt')
lookup = JSON.parse(lookup)
p(lookup)
]]
