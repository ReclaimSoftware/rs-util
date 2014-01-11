assert = require 'assert'
{rstrip} = require '../index'

describe "rstrip", () ->

  it "does nothing to 'foo bar'", () ->
    assert.equal rstrip("foo bar"), "foo bar"

  it "rstrips a blend of [ \\n\\r\\t]", () ->
    assert.equal rstrip("foo \n \r\t\t \r \n "), "foo"

  it "rstrips ' '", () -> assert.equal rstrip("foo  "), "foo"
  it "rstrips \\n", () -> assert.equal rstrip("foo\n\n"), "foo"
  it "rstrips \\r", () -> assert.equal rstrip("foo\r\r"), "foo"
  it "rstrips \\t", () -> assert.equal rstrip("foo\t\t"), "foo"

  it "does not lstrip ' '", () -> assert.equal rstrip("  foo"), "  foo"
  it "does not lstrip \\n", () -> assert.equal rstrip("\n\nfoo"), "\n\nfoo"
  it "does not lstrip \\r", () -> assert.equal rstrip("\r\rfoo"), "\r\rfoo"
  it "does not lstrip \\t", () -> assert.equal rstrip("\t\tfoo"), "\t\tfoo"
