{ljust} = require '../index'
assert = require 'assert'

describe "ljust", () ->

  it "ljusts the usual case", () -> assert.equal ljust('123', 5, '0'), '12300'
  it "ljusts the empty string", () -> assert.equal ljust('', 3, '0'), '000'
  it "ljusts when n already met", () -> assert.equal ljust('123', 3, '0'), '123'
  it "ljusts when n already exceeded", () -> assert.equal ljust('1234', 3, '0'), '1234'
