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
  intervalSet
  read_stream
  sum
  timeoutSet
}
