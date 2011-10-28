(function() {
  var Path, jasmine, p, treeParser;
  Path = require('path');
  jasmine = require('jasmine-node');
  treeParser = require(Path.join(__dirname, '..', 'lib', 'tree-parser')).treeParser;
  p = function(data, root) {
    if (root == null) {
      root = 'node';
    }
    return treeParser.parse(data, root);
  };
  describe('a node', function() {
    it('should parse with no children and no part', function() {
      return expect(p('[VoiceP]', 'node')).toEqual({
        label: 'VoiceP'
      });
    });
    it('should parse with a root in the name', function() {
      return expect(p('[\u221Anach]', 'node')).toEqual({
        label: '\u221Anach'
      });
    });
    it('should parse with no children and a single token part', function() {
      return expect(p('[VoiceP Hund]', 'node')).toEqual({
        label: 'VoiceP',
        part: 'Hund'
      });
    });
    it('should parse with no children and a multiple token part', function() {
      return expect(p('[VoiceP der Hund]', 'node')).toEqual({
        label: 'VoiceP',
        part: 'der Hund'
      });
    });
    it('should parse with one child and no part', function() {
      return expect(p('[VoiceP [DP]]', 'node')).toEqual({
        label: 'VoiceP',
        child_nodes: [
          {
            label: 'DP'
          }
        ]
      });
    });
    it('should parse with two children and no part', function() {
      return expect(p('[VoiceP [DP] [Voice\']]', 'node')).toEqual({
        label: 'VoiceP',
        child_nodes: [
          {
            label: 'DP'
          }, {
            label: 'Voice\''
          }
        ]
      });
    });
    it('should parse with two children and a single token part', function() {
      return expect(p('[VoiceP Hund [DP] [Voice\']]', 'node')).toEqual({
        label: 'VoiceP',
        part: 'Hund',
        child_nodes: [
          {
            label: 'DP'
          }, {
            label: 'Voice\''
          }
        ]
      });
    });
    return it('should parse with two children and a multiple token part', function() {
      return expect(p('[VoiceP der Hund [DP] [Voice\']]', 'node')).toEqual({
        label: 'VoiceP',
        part: 'der Hund',
        child_nodes: [
          {
            label: 'DP'
          }, {
            label: 'Voice\''
          }
        ]
      });
    });
  });
}).call(this);
