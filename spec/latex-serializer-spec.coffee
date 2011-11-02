require './init'

p = (data, root='drs') ->
  drsParser.parse(data, root)

l = (data, root='drs') ->
  ls.toLaTeX p(data, root)

describe 'LaTeX serializer', ->

  it 'should serialize a variable if it is an ascii token', ->
    expect(l('w', 'variable')).toEqual 'w'

  it 'should serialize a prefix relation', ->
    expect(l('agent(e,x)', 'prefix_relation')).toEqual 'agent(e, x)'
