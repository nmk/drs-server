(function() {
  var Path, drsParser, jasmine, p;
  Path = require('path');
  jasmine = require('jasmine-node');
  drsParser = require(Path.join(__dirname, '..', 'lib', 'drs-parser')).drsParser;
  p = function(data, root) {
    if (root == null) {
      root = 'drs';
    }
    return drsParser.parse(data, root);
  };
  describe('a lambda parameter', function() {
    it('should parse correctly', function() {
      return expect(p('^e.', 'lambda_parameter')).toEqual({
        _type: 'DRS::LambdaParameter',
        name: 'e'
      });
    });
    return it('should parse correctly when a latex symbol', function() {
      return expect(p('^$\\eta$.', 'lambda_parameter')).toEqual({
        _type: 'DRS::LambdaParameter',
        name: '$\\eta$'
      });
    });
  });
  describe('DRS', function() {
    it('should parse correctly when it has one store variable', function() {
      var result;
      result = p('<s,[|RIPE(s)]>');
      expect(result._type).toEqual('DRS::DRS');
      return expect(result.store_variables.length).toEqual(1);
    });
    return it('should parse correctly when it has one store variable', function() {
      var result;
      result = p('<s,e,[|RIPE(s)]>');
      expect(result._type).toEqual('DRS::DRS');
      return expect(result.store_variables.length).toEqual(2);
    });
  });
  describe('presupposition', function() {
    beforeEach(function() {
      return this.addMatchers({
        toBeADRS: function() {
          return this.actual._type === 'DRS::DRS';
        }
      });
    });
    it('should not parse when empty', function() {
      return expect(function() {
        return p('{}', 'presuppositions');
      }).toThrow();
    });
    it('should parse with one drs inside it', function() {
      var result;
      result = p('{[|]}', 'presuppositions');
      expect(result.length).toEqual(1);
      return expect(result[0]).toBeADRS();
    });
    return it('should parse with two drss inside it', function() {
      var result;
      result = p('{[|] [|]}', 'presuppositions');
      expect(result.length).toEqual(2);
      expect(result[0]).toBeADRS();
      return expect(result[1]).toBeADRS();
    });
  });
  describe('store', function() {
    it('should parse with one variable', function() {
      var result;
      result = p('<s,', 'store');
      return expect(result.length).toEqual(1);
    });
    return it('should parse with multiple variables', function() {
      var result;
      result = p('<s,e,', 'store');
      return expect(result.length).toEqual(2);
    });
  });
  describe('prefix relation', function() {
    beforeEach(function() {
      return this.addMatchers({
        toBeAPrefixRelation: function() {
          return this.actual._type === 'DRS::Relation' && !this.infix;
        },
        toBeAVariable: function() {
          return this.actual._type === 'DRS::Variable';
        }
      });
    });
    it('should parse correctly with no arguments', function() {
      var result;
      result = p('fail()', 'prefix_relation');
      expect(result._type).toEqual('DRS::Relation');
      expect(result.infix).toBe(void 0);
      expect(result.name).toEqual('fail');
      return expect(result.arguments).toEqual([]);
    });
    it('should parse correctly with one argument', function() {
      var argument, result;
      result = p('RIPE(s)', 'prefix_relation');
      expect(result._type).toEqual('DRS::Relation');
      expect(result.name).toEqual('RIPE');
      expect(result.arguments.length).toEqual(1);
      argument = result.arguments[0];
      return expect(argument).toEqual({
        _type: 'DRS::Variable',
        name: 's'
      });
    });
    it('should parse correctly with multiple argument', function() {
      var result;
      result = p('gives(x, y, z)', 'prefix_relation');
      expect(result._type).toEqual('DRS::Relation');
      expect(result.name).toEqual('gives');
      return expect(result.arguments.length).toEqual(3);
    });
    it('should parse correctly when nested', function() {
      var result;
      result = p('COPY(direction-of(W,e), direction-of(W, e\'))', 'prefix_relation');
      expect(result.arguments.length).toEqual(2);
      expect(result.arguments[0]).toBeAPrefixRelation();
      return expect(result.arguments[1]).toBeAPrefixRelation();
    });
    it('should parse correctly when arguments are mixed', function() {
      var result;
      result = p('COPY(direction-of(W,e), m)', 'prefix_relation');
      expect(result.arguments.length).toEqual(2);
      expect(result.arguments[0]).toBeAPrefixRelation();
      return expect(result.arguments[1]).toBeAVariable();
    });
    return it('should allow LaTeX code in the name', function() {
      var result;
      result = p('COPY$_\\mathrm{approx}$(direction-of(W, e), direction-of(W, e\'))', 'prefix_relation');
      return expect(result.name).toEqual('COPY$_\\mathrm{approx}$');
    });
  });
}).call(this);
