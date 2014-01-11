sum = (arr) ->
  result = 0
  for x in arr
    result += x
  result


timeoutSet = (x, y) ->
  setTimeout y, x


module.exports = {
  sum
  timeoutSet
}
