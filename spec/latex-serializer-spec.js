(function() {
  var Path, drsParser, jasmine, l, ls, p;
  Path = require('path');
  jasmine = require('jasmine-node');
  ls = require(Path.join(__dirname, '..', 'lib', 'latex-serializer')).LaTeXSerializer;
  drsParser = require(Path.join(__dirname, '..', 'lib', 'drs-parser')).drsParser;
  p = function(data, root) {
    if (root == null) {
      root = 'drs';
    }
    return drsParser.parse(data, root);
  };
  l = function(data, root) {
    if (root == null) {
      root = 'drs';
    }
    return ls.toLaTeX(p(data, root));
  };
  describe('a variable', function() {
    return it('should serialize to latex when it is an ascii token', function() {
      return expect(l('w', 'variable')).toEqual('{w}');
    });
  });
  describe('a relation', function() {
    return it('should serialize when prefix', function() {
      return expect(l('agent(e,x)', 'prefix_relation')).toEqual('agent({e}, {x})');
    });
  });
}).call(this);
