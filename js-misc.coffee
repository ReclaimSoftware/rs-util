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
  read_stream
  sum
  timeoutSet
}
