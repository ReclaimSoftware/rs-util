lstrip = (string) ->
  string.match(/^[ \t\n\r]*((.|[\r\n])*)$/)[1]


module.exports = {
  lstrip
}
