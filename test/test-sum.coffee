assert = require 'assert'
{sum} = require '../index'

describe "sum", () ->
  it "sums []", () -> assert.equal sum([]), 0
  it "sums [2]", () -> assert.equal sum([2]), 2
  it "sums [2, -0.5]", () -> assert.equal sum([2, -0.5]), 1.5
