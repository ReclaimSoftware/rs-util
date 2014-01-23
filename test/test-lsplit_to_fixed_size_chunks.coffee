{lsplit_to_fixed_sized_chunks} = require '../index'
assert = require 'assert'

describe "lsplit_to_fixed_sized_chunks", () ->

  it "splits to ['123', '456', '789']", () ->
    assert.deepEqual lsplit_to_fixed_sized_chunks('123456789', 3), ['123', '456', '789']

  it "splits to ['123', '456', '7']", () ->
    assert.deepEqual lsplit_to_fixed_sized_chunks('1234567', 3), ['123', '456', '7']

  it "splits to ['1']", () ->
    assert.deepEqual lsplit_to_fixed_sized_chunks('1', 3), ['1']

  it "splits to []", () ->
    assert.deepEqual lsplit_to_fixed_sized_chunks('', 3), []
