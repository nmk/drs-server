Path    = require 'path'

jasmine    = require 'jasmine-node'
drsParser  = require(Path.join __dirname, '..', 'lib', 'drs-parser').drsParser

p = (data, root='drs') ->
  drsParser.parse(data, root)

describe 'a lambda parameter', ->

  it 'should parse correctly', ->
    expect(p '^e.', 'lambda_parameter').toEqual({
      _type: 'DRS::LambdaParameter',
      name : 'e'
    })

  it 'should parse correctly when a latex symbol', ->
    expect(p '^$\\eta$.', 'lambda_parameter').toEqual({
      _type: 'DRS::LambdaParameter',
      name : '$\\eta$'
    })

describe 'DRS', ->

  it 'should parse correctly when it has one store variable', ->
    result = p '<s,[|RIPE(s)]>'

    expect(result._type).toEqual 'DRS::DRS'
    expect(result.store_variables.length).toEqual 1

  it 'should parse correctly when it has one store variable', ->
    result = p '<s,e,[|RIPE(s)]>'

    expect(result._type).toEqual 'DRS::DRS'
    expect(result.store_variables.length).toEqual 2

describe 'presupposition', ->

  beforeEach(->
    this.addMatchers(
      toBeADRS: ->
        this.actual._type == 'DRS::DRS'
    )
  )

  it 'should not parse when empty', ->
    expect(-> p '{}', 'presuppositions').toThrow()

  it 'should parse with one drs inside it', ->
    result = p '{[|]}', 'presuppositions'
    expect(result.length).toEqual(1)
    expect(result[0]).toBeADRS()

  it 'should parse with two drss inside it', ->
    result = p '{[|] [|]}', 'presuppositions'
    expect(result.length).toEqual(2)
    expect(result[0]).toBeADRS()
    expect(result[1]).toBeADRS()

describe 'store', ->

  it 'should parse with one variable', ->
    result = p('<s,', 'store')
    expect(result.length).toEqual 1

  it 'should parse with multiple variables', ->
    result = p '<s,e,', 'store'
    expect(result.length).toEqual 2

describe 'prefix relation', ->

  beforeEach(->
    this.addMatchers(
      toBeAPrefixRelation: ->
        this.actual._type == 'DRS::Relation' && !this.infix
      toBeAVariable: ->
        this.actual._type == 'DRS::Variable'
    )
  )

  it 'should parse correctly with no arguments', ->
    result = p 'fail()', 'prefix_relation'

    expect(result._type).toEqual 'DRS::Relation'
    expect(result.infix).toBe undefined
    expect(result.name).toEqual 'fail'
    expect(result.arguments).toEqual []

  it 'should parse correctly with one argument', ->
    result = p 'RIPE(s)', 'prefix_relation'

    expect(result._type).toEqual 'DRS::Relation'
    expect(result.name).toEqual 'RIPE'
    expect(result.arguments.length).toEqual 1

    argument = result.arguments[0]
    expect(argument).toEqual { _type: 'DRS::Variable', name: 's' }

  it 'should parse correctly with multiple argument', ->
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
