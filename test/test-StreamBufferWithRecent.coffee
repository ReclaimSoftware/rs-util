{StreamBufferWithRecent, timeoutSet, intervalSet} = require '../index'
{assert_data_equal, assert_raises} = require './helpers'
assert = require 'assert'
{EventEmitter} = require 'events'
{spawn} = require 'child_process'

describe "StreamBufferWithRecent", () ->

  it "can drink from a firehose", (done) ->
    subproc = spawn 'node', ['-e', """
      var kB = new Buffer(1000);
      var encoded_counter = new Buffer(4);
      var i = 0;
      while (true) {
        encoded_counter.writeUInt32LE(i, 0);
        process.stdout.write(encoded_counter);
        process.stdout.write(kB);
        i++;
      }
    """]
    stream = subproc.stdout
    capacity = 1016
    sb = new StreamBufferWithRecent {total_capacity: capacity, stream: subproc.stdout}

    assert.equal sb.num_bytes_obtained, 0
    assert.equal sb.num_bytes_consumed, 0
    assert.ok not sb.can_read_range(0, capacity)
    sb.wait_for_range {start: 0, end: capacity}, () ->
      assert.ok not sb.can_read_range 1004, 2004

      assert.equal sb.num_bytes_obtained, capacity
      assert.equal sb.num_bytes_consumed, 0
      assert_data_equal sb.slice(0, 4), new Buffer [0, 0, 0, 0]
      assert.equal sb.num_bytes_consumed, 4
      sb.slice(0, 1004)

      sb.wait_for_range {start: 1004, end: 2004}, () ->

        assert.equal sb.num_bytes_consumed, 1004
        assert_data_equal sb.slice(1004, 1004 + 4), new Buffer [1, 0, 0, 0]
        assert.equal sb.num_bytes_consumed, 1008

        subproc.kill 'SIGKILL'
        done()

  describe "wait_for_range", () ->

    it "calls the callback next tick if the range is readable", (done) ->
      stream = new MockReadableStream
      sb = new StreamBufferWithRecent {total_capacity: 10, stream}
      stream.emit 'data', new Buffer 'foo'
      callback_called = false
      sb.wait_for_range {start: 0, end: 1}, (e) ->
        assert.ok not e
        callback_called = true
        process.nextTick done
      assert.equal callback_called, false

    it "calls the callback when the range becomes readable", () ->
      stream = new MockReadableStream
      sb = new StreamBufferWithRecent {total_capacity: 10, stream}
      callback_called = false
      sb.wait_for_range {start: 0, end: 1}, (e) ->
        assert.ok not e
        callback_called = true
      assert.ok not callback_called
      stream.emit 'data', new Buffer "foo"
      assert.ok callback_called

    it "has an optional timeout", (done) ->
      stream = new MockReadableStream
      sb = new StreamBufferWithRecent {total_capacity: 10, stream}
      sb.wait_for_range {start: 0, end: 1, timeout: 1}, (e) ->
        assert.equal e.message, 'Timeout exceeded'
        done()

    it "does not call the callback if the range becomes readable after the timeout", (done) ->
      stream = new MockReadableStream
      sb = new StreamBufferWithRecent {total_capacity: 10, stream}
      sb.wait_for_range {start: 0, end: 1, timeout: 1}, (e) ->
        assert.equal e.message, 'Timeout exceeded'
        stream.emit 'data', new Buffer 'asdf'
        done()

    it "errors if you omit start", () ->
      stream = new MockReadableStream
      sb = new StreamBufferWithRecent {total_capacity: 10, stream}
      assert_raises 'Missing param: start', () ->
        sb.wait_for_range {end: 0}

    it "errors if you omit end", () ->
      stream = new MockReadableStream
      sb = new StreamBufferWithRecent {total_capacity: 10, stream}
      assert_raises 'Missing param: end', () ->
        throw new Error 'Missing param: end'
        sb.wait_for_range {start: 0}


class MockReadableStream extends EventEmitter


module.exports = {StreamBufferWithRecent}
