respond_error = (res, error="") ->
  console.log '----- Error, 500-ing -----'
  console.log error
  console.log '--------------------------'
  res.status(500).render('500')


respond_js = (res, code, js) ->
  _respond_text res, code, 'text/javascript', js


respond_json = (res, code, x) ->
  _respond_text res, code, 'application/json', JSON.stringify x, null, 2


respond_not_found = (res) ->
  res.status(404).render('404')


respond_storage_file = ({req, res, storage, key, mime}) ->
  {range} = req.headers
  storage.size key, (e, size) ->
    return respond_not_found res if e and e.notFound
    return respond_error res, e if e

    # No Range header?
    if not range
      res.writeHead 200, {'Content-Type': mime, 'Content-Length': size}
      storage.createReadStream(key).pipe res
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
    storage.createReadStream(key, {start, end}).pipe res


respond_plain = (res, code, text) ->
  _respond_text res, code, 'text/plain', text


_respond_text = (res, code, mime, text) ->
  data = new Buffer text, 'utf8'
  res.writeHead code, {
    'Content-Type': mime
  }
  res.end data


module.exports = {
  respond_error
  respond_js
  respond_json
  respond_not_found
  respond_storage_file
  respond_plain
}
