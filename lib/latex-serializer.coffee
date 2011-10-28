_ = require 'underscore'

class LaTeXSerializer
  @toLaTeX: (obj) ->
    objType = obj._type.split('::')[1].toLowerCase()
    this["#{objType}ToLaTeX"](obj)

  @variableToLaTeX: (o) ->
    "{#{o.name}}"

  @relationToLaTeX: (o) ->
    "#{o.name}(#{_(o.arguments).map((a) => @toLaTeX(a)).join(', ')})"

exports.LaTeXSerializer = LaTeXSerializer
