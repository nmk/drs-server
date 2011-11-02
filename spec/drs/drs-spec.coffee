require '../init'

p = (data, root='drs') ->
  drsParser.parse(data, root)

describe 'DRS', ->

  it 'should parse with presuppositions', ->
    result = p '<{[|]}[|]>'

    expect(result.presuppositions.length).toEqual 1

  it 'should serialize to LaTeX without a universe', ->
    drs = p '[|agent(e,x)]'
    ser = ls.toLaTeX(drs)

    expect(ser).toEqual '\\drs[]{agent(e, x)}'

  it 'should serialize to LaTeX with a universe', ->
    drs = p '[x| person(x) smile(x)]'
    ser = ls.toLaTeX(drs)

    expect(ser).toMatch 'universe={{x}}'

  it 'should searialize to LaTeX with lambda parameters', ->
    drs = p '^e.^x.[|agent(e, x)]'
    ser = ls.toLaTeX(drs)

    expect(ser).toMatch 'lambda={{e}, {x}}'

  it 'should serialize to LaTeX with store variables', ->
    drs = p '<s,[|RIPE(s)]>'
    ser = ls.toLaTeX(drs)

    expect(ser).toMatch 'store={{s}}'

  it 'should serialize to LaTeX with presuppositions', ->
    drs = p '<{[|]}[|RIPE(s)]>'
    ser = ls.toLaTeX(drs)

    expect(ser).toMatch escapeRegExp('presuppositions={{\\drs[]{}}}')
