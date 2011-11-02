_ = require 'underscore'

class LaTeXSerializer
  @toLaTeX: (obj) ->
    objType = obj._type.split('::')[1].toLowerCase()
    this["#{objType}ToLaTeX"](obj)

  @variableToLaTeX: (o) ->
    "#{o.name}"

  @relationToLaTeX: (o) ->
    "#{o.name}(#{_(o.arguments).map((a) => @toLaTeX(a)).join(', ')})"

  @discoursereferentToLaTeX: (o) ->
    "{#{o.name}}"

  @lambdaparameterToLaTeX: (o) ->
    "{#{o.name}}"

  @storevariableToLaTeX: (o) ->
    "{#{o.name}}"

  @drsToLaTeX: (o) ->
    r = '\\drs['

    universeStr = ''
    universeStr = "universe={#{_(o.universe).map((u) => @toLaTeX(u)).join(', ')}}" if !_.isEmpty(o.universe)

    lambdaStr = ''
    lambdaStr = "lambda={#{_(o.lambda_parameters).map((l) => @toLaTeX(l)).join(', ')}}" if !_.isEmpty(o.lambda_parameters)

    storeStr = ''
    storeStr = "store={#{_(o.store_variables).map((l) => @toLaTeX(l)).join(', ')}}" if !_.isEmpty(o.store_variables)

    presuppositionsStr = ''
    presuppositionsStr = "presuppositions={#{_(o.presuppositions).map((l) => "{#{@toLaTeX(l)}}").join(', ')}}" if !_.isEmpty(o.presuppositions)

    r += (prop for prop in [universeStr, lambdaStr, storeStr, presuppositionsStr] when ! _(prop).isEmpty()).join(', ')

    r += ']{'

    if o.conditions && o.conditions.length > 0
      r += _(o.conditions).map((c) => @toLaTeX(c)).join(' \\\\ ')

    r += '}'

exports.LaTeXSerializer = LaTeXSerializer
