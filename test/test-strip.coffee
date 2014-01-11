assert = require 'assert'
{strip} = require '../index'

describe "strip", () ->

  it "does nothing to 'foo bar'", () ->
    assert.equal strip("foo bar"), "foo bar"

  it "strips a blend of [ \\n\\r\\t]", () ->
    assert.equal strip(" \n \r\t\t \r \n foo \n \r\t\t \r \n "), "foo"

  it "rstrips ' '", () -> assert.equal strip("foo  "), "foo"
  it "rstrips \\n", () -> assert.equal strip("foo\n\n"), "foo"
  it "rstrips \\r", () -> assert.equal strip("foo\r\r"), "foo"
  it "rstrips \\t", () -> assert.equal strip("foo\t\t"), "foo"

  it "lstrips ' '", () -> assert.equal strip("  foo"), "foo"
  it "lstrips \\n", () -> assert.equal strip("\n\nfoo"), "foo"
  it "lstrips \\r", () -> assert.equal strip("\r\rfoo"), "foo"
  it "lstrips \\t", () -> assert.equal strip("\t\tfoo"), "foo"
