url = require 'url'
http = require 'http'


get = (expected_code, url, c) ->
  _request 'GET', expected_code, url, null, {}, c


get_info = (expected_code, url, c) ->
  get expected_code, url, _resParsing(c)


post_info = (expected_code, url, info, c) ->
  req_body = JSON.stringify info, null, 2
  headers = {'Content-Type': 'application/json'}
  _request 'POST', expected_code, url, req_body, headers, _resParsing(c)


_resParsing = (c) ->
  (e, res, body) ->
    return c e, res, body if e
    try
      info = JSON.parse body
    catch e
      return c (new Error "Error decoding JSON"), res, body
    c null, res, info


_request = (method, expected_code, _url, req_body, headers, c) ->
  {hostname, port, path} = url.parse _url
  opt = {
    method
    host: hostname
    port: parseInt(port, 10)
    path
    agent: false
    headers
  }
  req = http.request opt, (res) ->
    bufs = []
    res.on 'data', (data) -> bufs.push data
    res.on 'end', () ->
      body = Buffer.concat bufs
      res.data = body
      if res.statusCode != expected_code
        e = new Error "Unexpected status code: #{res.statusCode}"
        return c e, res
      c null, res, body
  if req_body
    req.end req_body
  else
    req.end()
  req.on 'error', (e) ->
    c e


module.exports = {get, get_info, post_info}
