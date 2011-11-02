require '../init'

p = (data, root='description') ->
  drsParser.parse(data, root)

describe 'description', ->

  it 'should parse with a relation description', ->
    result = p 's:HAVE(x)'

    expect(result).toBeADescription()
    expect(result.described).toBeAVariable()
    expect(result.description).toBeADRS()
    expect(result.description.conditions[0]).toBeAPrefixRelation()

  it 'should parse with a DRS description', ->
    result = p 's:[|]'

    expect(result).toBeADescription()
    expect(result.described).toBeAVariable()
    expect(result.description).toBeADRS()

  it 'should be recognized as a condition', ->
    result = p 's:[|]', 'condition'

    expect(result).toBeADescription()

  it 'should serialize to ASCII when the description is a single relation', ->
