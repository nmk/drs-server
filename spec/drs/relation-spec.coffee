require '../init'

p = (data, root='drs') ->
  drsParser.parse(data, root)

describe 'prefix relation', ->

  it 'should parse correctly with no arguments', ->
    result = p 'fail()', 'prefix_relation'

    expect(result._type).toEqual 'DRS::Relation'
    expect(result.infix).toBeFalsy()
    expect(result.name).toEqual 'fail'
    expect(result.arguments).toEqual []

  it 'should parse correctly with one argument', ->
    result = p 'RIPE(s)', 'prefix_relation'

    expect(result._type).toEqual 'DRS::Relation'
    expect(result.name).toEqual 'RIPE'
    expect(result.arguments.length).toEqual 1

    argument = result.arguments[0]
    expect(argument).toEqual { _type: 'DRS::Variable', name: 's' }

  it 'should parse correctly with multiple arguments', ->
    result = p 'gives(x, y, z)', 'prefix_relation'

    expect(result._type).toEqual 'DRS::Relation'
    expect(result.name).toEqual 'gives'
    expect(result.arguments.length).toEqual 3

  it 'should parse correctly when nested', ->
    result = p 'COPY(direction-of(W,e), direction-of(W, e\'))', 'prefix_relation'

    expect(result.arguments.length).toEqual 2
    expect(result.arguments[0]).toBeAPrefixRelation()
    expect(result.arguments[1]).toBeAPrefixRelation()

  it 'should parse correctly when arguments are mixed', ->
    result = p 'COPY(direction-of(W,e), m)', 'prefix_relation'

    expect(result.arguments.length).toEqual 2
    expect(result.arguments[0]).toBeAPrefixRelation()
    expect(result.arguments[1]).toBeAVariable()

  it 'should allow LaTeX code in the name', ->
    result = p 'COPY$_\\mathrm{approx}$(direction-of(W, e), direction-of(W, e\'))', 'prefix_relation'

    expect(result.name).toEqual 'COPY$_\\mathrm{approx}$'

describe 'infix relation', ->

  it 'should parse correctly with variable arguments', ->
    for parseType in [ 'infix_relation', 'relation', 'condition' ]
      do (parseType) ->
        result = p 'e CAUSE s', parseType

        expect(result).toBeARelation()
        expect(result).toBeAnInfixRelation()
        expect(result.name).toEqual 'CAUSE'
        expect(result.arguments.length).toEqual 2
        expect(result.arguments[0]).toBeAVariable()
        expect(result.arguments[1]).toBeAVariable()

  it 'should allow a variable and a prefix relation as arguments', ->

    for parseType in ['infix_relation', 'relation', 'condition']
      do (parseType) ->
        result = p 'e CAUSE foo(a, b)', parseType

        expect(result).toBeARelation()
        expect(result).toBeAnInfixRelation()
        expect(result.arguments[0]).toBeAVariable()
        expect(result.arguments[1]).toBeAPrefixRelation()
        expect(result.arguments[1].name).toEqual 'foo'
