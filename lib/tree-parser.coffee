Fs   = require 'fs'
Path = require 'path'
PEG  = require 'pegjs'

grammarFile   = Path.join __dirname, '..', 'grammars', 'tree.grammar'
grammarSource = Fs.readFileSync grammarFile, 'ascii'

exports.treeParser = PEG.buildParser grammarSource
