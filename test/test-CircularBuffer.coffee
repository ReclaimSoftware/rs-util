{CircularBuffer} = require '../index'
{assert_raises, assert_data_equal} = require './helpers'
assert = require 'assert'

describe "CircularBuffer", () ->

  it "handles multiple writes", () ->
    cb = new CircularBuffer 9
    cb.append new Buffer 'abc'
    cb.append new Buffer '123'
    cb.append new Buffer 'xyz'
    assert_data_equal cb._buffer, new Buffer 'abc123xyz'
    assert_data_equal cb.slice(1, 7), new Buffer 'bc123x'

  it "handles a wrap", () ->
    cb = new CircularBuffer 4
    cb.append new Buffer '01'
    cb.append new Buffer '234'
    assert_data_equal cb._buffer, new Buffer '4123'
    assert_data_equal cb.slice(1, 5), new Buffer '1234'

  describe "can_read_range", () ->
    cb = new CircularBuffer 4
    cb.append new Buffer 'abc'
    cb.append new Buffer 'de'

    it "is false if start is out of bounds", () ->
      assert.strictEqual cb.can_read_range(0, 2), false

    it "is true if start is almost out of bounds", () ->
      assert.strictEqual cb.can_read_range(1, 2), true

    it "if false if end is out of bounds", () ->
      assert.strictEqual cb.can_read_range(1, 6), false

    it "is true if end is almost out of bounds", () ->
      assert.strictEqual cb.can_read_range(1, 5), true

  describe "slice", () ->
    cb = new CircularBuffer 4
    cb.append new Buffer 'abc'
    cb.append new Buffer 'de'

    it "errors if start is out of bounds", () ->
      assert_raises 'start is of bounds', () -> cb.slice 0, 2

    it "does not error if start is almost out of bounds", () ->
      assert_data_equal cb.slice(1, 2), new Buffer 'b'

    it "errors if end is out of bounds", () ->
      assert_raises 'end is of bounds', () -> cb.slice 1, 6

    it "does not error if end is almost out of bounds", () ->
      assert_data_equal cb.slice(1, 5), new Buffer 'bcde'


  describe "write", () ->

    it "errors if the data being written exceeds the capacity", () ->
      cb = new CircularBuffer 10
      data = new Buffer 11
      assert_raises "Data exceeds capacity", () -> cb.append data

    it "does not error if the size of the data being written equals the capacity", () ->
      cb = new CircularBuffer 10
      data = new Buffer 10
      cb.append data
