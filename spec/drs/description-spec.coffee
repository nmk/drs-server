require '../init'

p = (data, root='description') ->
  drsParser.parse(data, root)

describe 'description', ->

  xit 'with a relation description', ->
    result = p 's:HAVE(x)'
