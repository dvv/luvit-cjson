JSON for Luvit
=====

[![Build Status](https://secure.travis-ci.org/luvit/json.png)](http://travis-ci.org/luvit/json)

Usage
-----

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

License
-------

[MIT](cjson/license.txt)
