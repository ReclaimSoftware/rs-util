ljust = (string, n, char) ->
  while string.length < n
    string = string + char
  string


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
  lstrip
  rjust
  rstrip
  strip
}
