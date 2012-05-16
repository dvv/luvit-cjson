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
    -- append new data to previous data
    self.data = (self.data or '') .. str
    --
    while true do
      local status, result = pcall(parse, self.data)
      if status then
        callback(result)
        return
      end
      --print(result, str)
      -- more data than needed for the single value?
      if result:find('Expected the end ', nil, true) == 1 then
        local at = result:find(' at character ', nil, true)
        -- consume the first value and try retry parsing
        if at then
          at = tonumber(result:sub(at + 14))
          if at then
            callback(parse(self.data:sub(1, at - 1)))
            self.data = self.data:sub(at)
          end
        end
      -- not enough data?
      elseif result:find(' but found T_END at character ', nil, true) then
        return
      -- not streaming error
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
    -- more data than needed for the single value?
    if result:find('Expected the end ', nil, true) == 1 then
      local at = result:find(' at character ', nil, true)
      -- consume the first value and try retry parsing
      if at then
        at = tonumber(result:sub(at + 14))
        if at then
          results[#results + 1] = parse(str:sub(1, at - 1))
          str = str:sub(at)
        end
      end
    -- relay other errors
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
