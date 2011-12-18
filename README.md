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

Check [here](license.txt).
