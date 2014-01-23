ljust = (string, n, char) ->
  while string.length < n
    string = string + char
  string


lsplit_to_fixed_sized_chunks = (string, chunk_size) ->
  chunks = []
  i = 0
  while i < string.length
    chunks.push string.substr i, chunk_size
    i += chunk_size
  chunks


lstrip = (string) ->
  string.match(/^[ \t\n\r]*((.|[\r\n])*)$/)[1]


rjust = (string, n, char) ->
  while string.length < n
    string = char + string
  string


rstrip = (string) ->
  string.match(/^((.|[\r\n])*?)[ \t\n\r]*$/)[1]


strip = (s) ->
  lstrip rstrip s


module.exports = {
  ljust
  lsplit_to_fixed_sized_chunks
  lstrip
  rjust
  rstrip
  strip
}
