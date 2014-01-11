assert = require 'assert'
{lstrip} = require '../index'

describe "lstrip", () ->

  it "does nothing to 'foo bar'", () ->
    assert.equal lstrip("foo bar"), "foo bar"

  it "lstrips a blend of [ \\n\\r\\t]", () ->
    assert.equal lstrip(" \n \r\t\t \r \n foo"), "foo"

  it "lstrips ' '", () -> assert.equal lstrip("  foo"), "foo"
  it "lstrips \\n", () -> assert.equal lstrip("\n\nfoo"), "foo"
  it "lstrips \\r", () -> assert.equal lstrip("\r\rfoo"), "foo"
  it "lstrips \\t", () -> assert.equal lstrip("\t\tfoo"), "foo"

  it "does not rstrip ' '", () -> assert.equal lstrip("foo  "), "foo  "
  it "does not rstrip \\n", () -> assert.equal lstrip("foo\n\n"), "foo\n\n"
  it "does not rstrip \\r", () -> assert.equal lstrip("foo\r\r"), "foo\r\r"
  it "does not rstrip \\t", () -> assert.equal lstrip("foo\t\t"), "foo\t\t"
