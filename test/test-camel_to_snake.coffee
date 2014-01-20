assert = require 'assert'
{camel_to_snake} = require '../index'

describe "camel_to_snake", () ->

  it "maps '' -> ''", () -> assert.equal camel_to_snake(''), ''

  it "maps Foo -> foo", () -> assert.equal camel_to_snake('Foo'), 'foo'
  it "maps FooBar -> foo_bar", () -> assert.equal camel_to_snake('FooBar'), 'foo_bar'
  it "maps ABTest -> a_b_test", () -> assert.equal camel_to_snake('ABTest'), 'a_b_test'

  it "maps foo -> foo", () -> assert.equal camel_to_snake('foo'), 'foo'
  it "maps fooBar -> foo_bar", () -> assert.equal camel_to_snake('fooBar'), 'foo_bar'
