require '../init'

p = (data, root='description') ->
  drsParser.parse(data, root)

describe 'description', ->

  describe 'should parse correctly', ->

    xit 'with a relation description', ->
      result = p 's:HAVE(x)'
