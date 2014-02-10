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

ljust "123", 5, " "       #-> "123  "
rjust "123", 5, "0"       #-> "00123"

lsplit_to_fixed_sized_chunks "1234567", 3   #-> ["123", "456", "7"]
```


### Buffering data

`start` and `end` refer to the entire stream of data, not what happens to be in the buffer.

#### CircularBuffer

```coffee
cb = new CircularBuffer 200e6
cb.append buf
if cb.can_read_range start, end
  cb.slice start, end
```

#### StreamBufferWithRecent

```coffee
sb = new StreamBufferWithRecent {stream, total_capacity, history_capacity}
sb.wait_for_range {start, end, timeout: 1000}, () ->
  if sb.can_read_range start, end
    sb.slice start, end
```

Under the hood, `StreamBufferWithRecent` will

- use a `CircularBuffer` with `total_capacity` bytes
- pause/resume the stream as needed
- maintain `history_capacity` bytes of history


### Misc

```coffee
sum [2, 2]                #-> 4

timeoutSet = (x, y) -> setTimeout y, x
intervalSet = (x, y) -> setInterval y, x

read_stream stream, (data) ->
read_fixed_size_chunks stream, chunk_size, (data) ->

copy_buffer buf
````


### HTTP responding

```coffee

respond_plain res, code, text   # text/plain
respond_js res, code, js        # text/javascript
respond_json res, code, value   # application/json, pretty-printed JSON of value
respond_jsonp res, code, value  # text/javascript, "#{callback}(#{json})"
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
