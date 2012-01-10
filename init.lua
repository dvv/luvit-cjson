local JSON = require('./build/cjson/cjson')
_G.cjson = nil

return {
  stringify = JSON.encode,
  parse = JSON.decode,
  null = JSON.null,
}
