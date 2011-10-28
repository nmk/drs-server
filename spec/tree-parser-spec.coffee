Path    = require 'path'

jasmine     = require 'jasmine-node'
treeParser  = require(Path.join __dirname, '..', 'lib', 'tree-parser').treeParser

p = (data, root='node') ->
  treeParser.parse(data, root)

describe 'a node', ->

  it 'should parse with no children and no part', ->
    expect(p('[VoiceP]', 'node')).toEqual({
      label: 'VoiceP'
    })

  it 'should parse with no children and a single token part', ->
    expect(p('[VoiceP Hund]', 'node')).toEqual({
      label: 'VoiceP',
      part:  'Hund'
    })

  it 'should parse with no children and a multiple token part', ->
    expect(p('[VoiceP der Hund]', 'node')).toEqual({
      label: 'VoiceP',
      part:  'der Hund'
    })

  it 'should parse with one child and no part', ->
    expect(p('[VoiceP [DP]]', 'node')).toEqual({
      label: 'VoiceP',
      child_nodes: [ {label: 'DP'} ]
    })

  it 'should parse with two children and no part', ->
    expect(p('[VoiceP [DP] [Voice\']]', 'node')).toEqual({
      label: 'VoiceP',
      child_nodes: [ {label: 'DP'}, {label: 'Voice\''} ]
    })

  it 'should parse with two children and a single token part', ->
    expect(p('[VoiceP Hund [DP] [Voice\']]', 'node')).toEqual({
      label: 'VoiceP',
      part:  'Hund',
      child_nodes: [ {label: 'DP'}, {label: 'Voice\''} ]
    })

  it 'should parse with two children and a multiple token part', ->
    expect(p('[VoiceP der Hund [DP] [Voice\']]', 'node')).toEqual({
      label: 'VoiceP',
      part:  'der Hund',
      child_nodes: [ {label: 'DP'}, {label: 'Voice\''} ]
    })
