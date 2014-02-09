crypto = require 'crypto'


copy_buffer = (buffer) ->
  result = new Buffer buffer.length
  buffer.copy result
  result


sha1_hex_of = (data) ->
  data = data.toString('utf8') if (typeof data) == 'string'
  hash = crypto.createHash 'sha1'
  hash.update data
  hash.digest 'hex'


module.exports = {
  copy_buffer
  sha1_hex_of
}
