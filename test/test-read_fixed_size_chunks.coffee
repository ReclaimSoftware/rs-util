assert = require 'assert'
{EventEmitter} = require 'events'
{read_fixed_size_chunks} = require '../index'

describe "read_fixed_size_chunks", () ->

  it "can read multiple chunks from one data event", () ->
    stream = new MockStream
    chunks_hex = []
    read_fixed_size_chunks stream, 2, (chunk, i) ->
      chunks_hex.push chunk.toString('hex')
    stream.emit 'data', new Buffer "1"
    stream.emit 'data', new Buffer "2345"
    stream.emit 'data', new Buffer "6"
    assert.equal chunks_hex.length, 3
    assert.equal chunks_hex[0], '3132'
    assert.equal chunks_hex[1], '3334'
    assert.equal chunks_hex[2], '3536'


class MockStream extends EventEmitter
