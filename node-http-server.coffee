respond_error = (res, error="") ->
  console.log '----- Error, 500-ing -----'
  console.log error
  console.log '--------------------------'
  respond_plain res, 500, "Internal Error.\n"


respond_js = (res, code, js) ->
  res.writeHead code, {'Content-Type': 'application/javascript'}
  res.end js


respond_json = (res, code, x) ->
  res.writeHead code, {'Content-Type': 'application/json'}
  res.end JSON.stringify x, null, 2


respond_plain = (res, code, text) ->
  res.writeHead code, {'Content-Type': 'text/plain'}
  res.end text


module.exports = {
  respond_error
  respond_js
  respond_json
  respond_plain
}
