assert = require 'assert'
{sha1_hex_of} = require '../index'

describe "sha1_hex_of", () ->

  it "hashes the empty string", () ->
    assert.equal sha1_hex_of(new Buffer []), 'da39a3ee5e6b4b0d3255bfef95601890afd80709'

  it "hashes 'C0FFEE'", () ->
    assert.equal sha1_hex_of(new Buffer 'C0FFEE', 'hex'), '1c835deb843e6421e5d87216f97cfaa4c32c5264'

  it "hashes 'foo' when passed as data", () ->
    assert.equal sha1_hex_of(new Buffer '666F6F', 'hex'), '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33'

  it "hashes 'foo' when passed as text", () ->
    assert.equal sha1_hex_of('foo'), '0beec7b5ea3f0fdbc95d0dd47f3c5bc275da8a33'
