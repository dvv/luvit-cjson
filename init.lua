local JSON = require('./build/cjson/cjson')
_G.cjson = nil

local parse = JSON.decode

local function parseMany(str)
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
    end
  end
end

return {
  stringify = JSON.encode,
  parse = parse,
  parseMany = parseMany,
  null = JSON.null,
}
