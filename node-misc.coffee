crypto = require 'crypto'


sha1_hex_of = (data) ->
  data = data.toString('utf8') if (typeof data) == 'string'
  hash = crypto.createHash 'sha1'
  hash.update data
  hash.digest 'hex'


module.exports = {
  sha1_hex_of
}
