**Some generic stuff, all in a single namespace.**

[![Build Status](https://secure.travis-ci.org/ReclaimSoftware/rs-util.png)](http://travis-ci.org/ReclaimSoftware/rs-util)

```coffee
{...} = require 'rs-util'
```


### String functions

```coffee
camel_to_snake "FooBar"   #-> "foo_bar"
lstrip " foo \n\r\t"      #-> "foo \n\r\t"
rstrip " foo \n\r\t"      #-> " foo"
strip "  foo \n\r\t"      #-> "foo"
```


### Misc

```coffee
sum [2, 2]                #-> 4

timeoutSet = (x, y) -> setTimeout y, x
intervalSet = (x, y) -> setInterval y, x

read_stream stream, (data) ->
read_fixed_size_chunks stream, chunk_size, (data) ->
````


### HTTP responding

```coffee

respond_plain res, code, text # text/plain
respond_js res, code, js      # application/javascript
respond_json res, code, value # application/json, pretty-printed JSON of value
respond_storage_file {req, res, storage, key, mime} # supports partial content!

respond_error res, e          # res.status(500).render('500') and console.log
respond_not_found res         # res.status(404).render('404')
```


### HTTP requesting

*For when you want your HTTP magic to be opt-in, not opt-out.*

```coffee
get expected_code, url, (e, res, body_buffer) ->

get_info expected_code, url, (e, res, decoded_json_value) ->

post_info expected_code, url, value, (e, res, decoded_json_value) ->
```


### [License: MIT](LICENSE.txt)
