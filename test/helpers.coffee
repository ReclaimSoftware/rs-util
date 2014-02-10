assert = require 'assert'


assert_data_equal = (x, y) ->
  assert.equal x.toString('hex'), y.toString('hex')


assert_raises = (message, f) ->
  try
    f()
  catch e
    assert.equal e.message, message
    return
  throw new Error "Expected an error"


module.exports = {
  assert_data_equal
  assert_raises
}
