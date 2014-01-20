camel_to_snake = (camel) ->
  # I'm sure there's a better implementation,
  # but this one works for now
  m = null
  regex = /[A-Z]/
  next = () ->
    camel = camel.substr(0, 1).toLowerCase() + camel.substr(1)
    m = camel.match regex
  bits = []
  next()
  while m and camel.length > 0
    bits.push camel.substr 0, m.index
    camel = camel.substr m.index
    next()
  if camel.length > 0
    bits.push camel
  bits.join '_'


intervalSet = (x, y) ->
  setInterval y, x


# Note: after your callback returns,
# the buffer it was passed will be overwritten.
# `.copy` it or lose it.
read_fixed_size_chunks = (stream, chunk_size, c) ->
  chunk = new Buffer chunk_size
  chunk_pos = 0
  stream.on 'data', (new_data) ->
    new_data_remaining = new_data.length

    # Can we emit one?
    needed_for_next = chunk_size - chunk_pos
    if needed_for_next <= new_data.length
      new_data.copy chunk, chunk_pos, 0, needed_for_next
      c chunk
      new_data_remaining -= needed_for_next
      chunk_pos = 0

    # The buffer from the past is empty.
    # Emit chunks (if any) from the remainder of new_data.
    while new_data_remaining >= chunk_size
      start = (new_data.length - new_data_remaining)
      c new_data.slice start, start + chunk_size
      new_data_remaining -= chunk_size

    # Save remainder to buffer
    if new_data_remaining > 0
      start = new_data.length - new_data_remaining
      new_data.copy chunk, chunk_pos, start, start + new_data_remaining
      chunk_pos += new_data_remaining


read_stream = (stream, c) ->
  buffers = []
  stream.on 'data', (data) -> buffers.push data
  stream.on 'end', () -> c null, Buffer.concat(buffers) if c
  stream.on 'error', (e) ->
    c e
    c = null


sum = (arr) ->
  result = 0
  for x in arr
    result += x
  result


timeoutSet = (x, y) ->
  setTimeout y, x


module.exports = {
  camel_to_snake
  intervalSet
  read_fixed_size_chunks
  read_stream
  sum
  timeoutSet
}
