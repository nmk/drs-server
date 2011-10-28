Path = require 'path'

jasmine     = require 'jasmine-node'
ls          = require(Path.join __dirname, '..', 'lib', 'latex-serializer').LaTeXSerializer
drsParser   = require(Path.join __dirname, '..', 'lib', 'drs-parser').drsParser

p = (data, root='drs') ->
  drsParser.parse(data, root)

l = (data, root='drs') ->
  ls.toLaTeX p(data, root)

describe 'a variable', ->
  it 'should serialize to latex when it is an ascii token', ->
    expect(l('w', 'variable')).toEqual '{w}'

describe 'a relation', ->
  it 'should serialize when prefix', ->
    expect(l('agent(e,x)', 'prefix_relation')).toEqual 'agent({e}, {x})'
