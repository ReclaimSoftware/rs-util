{rjust} = require '../index'
assert = require 'assert'

describe "rjust", () ->

  it "rjusts the usual case", () -> assert.equal rjust('123', 5, '0'), '00123'
  it "rjusts the empty string", () -> assert.equal rjust('', 3, '0'), '000'
  it "rjusts when n already met", () -> assert.equal rjust('123', 3, '0'), '123'
  it "rjusts when n already exceeded", () -> assert.equal rjust('1234', 3, '0'), '1234'
