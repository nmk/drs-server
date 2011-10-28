Fs   = require 'fs'
Path = require 'path'
PEG  = require 'pegjs'

grammarFile   = Path.join __dirname, '..', 'grammars', 'drs.grammar'
grammarSource = Fs.readFileSync grammarFile, 'ascii'

exports.drsParser = PEG.buildParser(grammarSource)
