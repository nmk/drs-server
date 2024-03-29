Path    = require 'path'
require 'jasmine-node'

beforeEach ->
  this.addMatchers
    toBeARelation: ->
      this.actual._type == 'DRS::Relation'
    toBeAnInfixRelation: ->
      this.actual._type == 'DRS::Relation' && this.actual.infix
    toBeAPrefixRelation: ->
      this.actual._type == 'DRS::Relation' && !this.actual.infix
    toBeAVariable: ->
      this.actual._type == 'DRS::Variable'
    toBeADRS: ->
      this.actual._type == 'DRS::DRS'
    toBeADescription: ->
      this.actual._type == 'DRS::Description'

global.drsParser  = require(Path.join __dirname, '..', 'lib', 'drs-parser').drsParser
global.treeParser = require(Path.join __dirname, '..', 'lib', 'tree-parser').treeParser
global.ls         = require(Path.join __dirname, '..', 'lib', 'latex-serializer').LaTeXSerializer

global.escapeRegExp = (str) -> str.replace(/([.*+?^${}()|[\]\/\\])/g, '\\$1')
