lstrip = (string) ->
  string.match(/^[ \t\n\r]*((.|[\r\n])*)$/)[1]


rstrip = (string) ->
  string.match(/^((.|[\r\n])*?)[ \t\n\r]*$/)[1]


module.exports = {
  lstrip
  rstrip
}
