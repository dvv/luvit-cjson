local JSON = require './build/cjson/cjson'
_G.cjson = nil

local String = require('string')

  -- Based on luajson code (comments copied verbatim).
  -- https://github.com/harningt/luajson/blob/master/lua/json/encode/strings.lua

  local matches =
  {
--[[    ['"'] = '\\"';
    ['\\'] = '\\\\';
--    ['/'] = '\\/'; -- TODO: ?! Do we really need to escape this?
    ['\b'] = '\\b';
    ['\f'] = '\\f';
    ['\n'] = '\\n';
    ['\r'] = '\\r';
    ['\t'] = '\\t';
    ['\v'] = '\\v'; -- not in official spec, on report, removing]]--
  }

  -- Pre-encode the control characters to speed up encoding...
  -- NOTE: UTF-8 may not work out right w/ JavaScript
  -- JavaScript uses 2 bytes after a \u... yet UTF-8 is a
  -- byte-stream encoding, not pairs of bytes (it does encode
  -- some letters > 1 byte, but base case is 1)
  for i = 0, 255 do
    local c = String.char(i)
    if c:match('[%z\1-\031\128-\255]') and not matches[c] then
      -- WARN: UTF8 specializes values >= 0x80 as parts of sequences...
      --       without \x encoding, do not allow encoding > 7F
      matches[c] = String.format('\\u%.4X', i)
    end
  end

--escapable = /[\x00-\x1f\ud800-\udfff\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufff0-\uffff]/g
JSON.escape = function(str)
  return String.gsub(str, '[\\"/%z\1-\031]', matches)
end

return {
  stringify = JSON.encode,
  parse = JSON.decode,
  null = JSON.null,
}
