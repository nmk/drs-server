(function() {
  var LaTeXSerializer, _;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  _ = require('underscore');
  LaTeXSerializer = (function() {
    function LaTeXSerializer() {}
    LaTeXSerializer.toLaTeX = function(obj) {
      var objType;
      objType = obj._type.split('::')[1].toLowerCase();
      return this["" + objType + "ToLaTeX"](obj);
    };
    LaTeXSerializer.variableToLaTeX = function(o) {
      return "{" + o.name + "}";
    };
    LaTeXSerializer.relationToLaTeX = function(o) {
      return "" + o.name + "(" + (_(o.arguments).map(__bind(function(a) {
        return this.toLaTeX(a);
      }, this)).join(', ')) + ")";
    };
    return LaTeXSerializer;
  })();
  exports.LaTeXSerializer = LaTeXSerializer;
}).call(this);
