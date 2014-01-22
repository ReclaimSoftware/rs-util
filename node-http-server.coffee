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


respond_local_file = ({req, res, local_path, mime}) ->
  {range} = req.headers
  fs.stat local_path, (e, stats) ->
    return respond_error res, e if e
    return respond_error res, 'not a file' if not stats.isFile()
    {size} = stats

    # No Range header?
    if not range
      res.writeHead 200, {'Content-Type': mime, 'Content-Length': size}
      fs.createReadStream(local_path).pipe res
      return

    m = range.match /^bytes=([0-9]+)-/
    start = parseInt m[1], 10
    m = range.match /^bytes=([0-9]+)-([0-9]+)/
    end = if m then parseInt(m[2], 10) else (size - 1)
    res_size = end - start + 1

    # invalid range?
    if (start > end) or ((end + 1) > size)
      return respond_plain res, 416, "invalid range"

    res.writeHead 206, {
      'Content-Type': mime
      'Content-Length': res_size
      'Content-Range': "bytes #{start}-#{end}/#{size}"
    }
    fs.createReadStream(local_path, {start, end}).pipe res


respond_plain = (res, code, text) ->
  res.writeHead code, {'Content-Type': 'text/plain'}
  res.end text


module.exports = {
  respond_error
  respond_js
  respond_json
  respond_local_file
  respond_plain
}
