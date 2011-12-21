JSON for Luvit
=====

[![Build Status](https://secure.travis-ci.org/luvit/json.png)](http://travis-ci.org/luvit/json)

Usage
-----

    // import module
    local JSON = require('json')

    // simple encode/decode loop
    local obj, serialized, content
    obj = { 1, 2, 3, 4 }
    p(obj)
    serialized = JSON.encode(obj)
    p(serialized)
    content = JSON.decode(serialized)
    p(content)
    assert(obj[2] == content[2])

License
-------

[MIT](json/license.txt)
