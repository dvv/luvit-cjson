local JSON = require('./build/cjson/cjson')
_G.cjson = nil

local parse = JSON.decode

local function streamingParser(callback, options)
  local self = {}
  self.options = options
  self.parse = function(self, str)
    if not self.options or not self.options.allow_multiple_values then
      callback(parse(str))
      return
    end
    while true do
      local status, result = pcall(parse, str)
      if status then
        callback(result)
        return
      end
      --print(result, str)
      if result:find('Expected the end ', nil, true) == 1 then
        local at = result:find(' at character ', nil, true)
        if at then
          at = tonumber(result:sub(at + 14))
          if at then
            callback(parse(str:sub(1, at - 1)))
            str = str:sub(at)
          end
        end
      else
        error(result)
      end
    end
  end
  --
  return self
end

local function parseMany(str, options)
  if not options or not options.allow_multiple_values then
    return parse(str)
  end
  --
  local results = {}
  while true do
    local status, result = pcall(parse, str)
    if status then
      results[#results + 1] = result
      return results
    end
    --print(result, str)
    if result:find('Expected the end ', nil, true) == 1 then
      local at = result:find(' at character ', nil, true)
      if at then
        at = tonumber(result:sub(at + 14))
        if at then
          results[#results + 1] = parse(str:sub(1, at - 1))
          str = str:sub(at)
        end
      end
    else
      error(result)
    end
  end
end

return {
  stringify = JSON.encode,
  parse = parseMany,
  streamingParser = streamingParser,
  null = JSON.null,
}
