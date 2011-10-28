(function() {
  var drawEdge, drawTree, labelStyle, moveTree, partStyle, treeWidth, visualize;
  labelStyle = {
    'font-size': 16,
    'font-family': "'Hoefler Text', serif"
  };
  partStyle = {
    'font-size': 16,
    'font-family': "'Hoefler Text', serif",
    'font-style': 'italic'
  };
  treeWidth = function(tree) {
    if (tree.part) {
      return Math.max(tree.label.getBBox().width, tree.part.getBBox().width, _(tree.subTrees || []).map(function(t) {
        return treeWidth(t);
      }).reduce((function(o, n) {
        return o + n;
      }), 0));
    } else {
      return Math.max(tree.label.getBBox().width, _(tree.subTrees || []).map(function(t) {
        return treeWidth(t);
      }).reduce((function(o, n) {
        return o + n;
      }), 0));
    }
  };
  drawEdge = function(paper, start, end) {
    var endBBox, pathDef, startBBox, startY, _ref;
    _ref = [start.label.getBBox(), end.label.getBBox()], startBBox = _ref[0], endBBox = _ref[1];
    startY = startBBox.y + startBBox.height + 4;
    if (start.part) {
      startY += start.part.getBBox().height + 4;
    }
    pathDef = "M" + (startBBox.x + startBBox.width / 2) + ", " + startY + "              L" + (endBBox.x + endBBox.width / 2) + ", " + (endBBox.y - 4);
    return paper.path(pathDef);
  };
  moveTree = function(paper, tree, x, y) {
    var edge, movedTree, subTree, _i, _j, _len, _len2, _ref, _ref2;
    tree.label.translate(x, y);
    if (tree.part) {
      tree.part.translate(x, y);
    }
    _ref = tree.edges;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      edge = _ref[_i];
      edge.remove();
    }
    tree.edges = [];
    _ref2 = tree.subTrees;
    for (_j = 0, _len2 = _ref2.length; _j < _len2; _j++) {
      subTree = _ref2[_j];
      movedTree = moveTree(paper, subTree, x, y);
      tree.edges.push(drawEdge(paper, tree, movedTree));
    }
    return tree;
  };
  drawTree = function(paper, treeDef, level) {
    var child, index, label, part, subTree, subTrees, vertOffsetForNextLevel, widthOfAllSubTrees, _len;
    if (level == null) {
      level = 0;
    }
    label = paper.text(0, 0, treeDef.label).attr(labelStyle);
    if (treeDef.part) {
      part = paper.text(0, label.getBBox().height + 5, treeDef.part).attr(partStyle);
    }
    subTrees = (function() {
      var _i, _len, _ref, _results;
      _ref = treeDef.child_nodes || [];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        child = _ref[_i];
        _results.push(drawTree(paper, child, level + 1));
      }
      return _results;
    })();
    widthOfAllSubTrees = _(subTrees).map(function(t) {
      return treeWidth(t);
    }).reduce((function(o, n) {
      return o + n;
    }), 0);
    vertOffsetForNextLevel = 35 + label.getBBox().height;
    if (part) {
      vertOffsetForNextLevel += part.getBBox().height + 20;
    }
    if (subTrees.length === 1) {
      moveTree(paper, subTrees[0], 0, 50);
    } else {
      for (index = 0, _len = subTrees.length; index < _len; index++) {
        subTree = subTrees[index];
        moveTree(paper, subTree, index * widthOfAllSubTrees - widthOfAllSubTrees / subTrees.length, vertOffsetForNextLevel);
      }
    }
    return {
      label: label,
      part: part,
      subTrees: subTrees,
      edges: []
    };
  };
  visualize = function(data) {
    var drawnTree, result;
    if (window.paper) {
      window.paper.clear();
    } else {
      window.paper = Raphael('canvas');
    }
    $('div#message').hide();
    try {
      result = treeParser.parse(data);
      drawnTree = drawTree(paper, result);
      return moveTree(window.paper, drawnTree, Math.round(window.paper.width / 2), 20);
    } catch (error) {
      return $('div#message').html(error.message).show();
    }
  };
  $(document).ready(function() {
    var $inputArea, $parseButton, _ref;
    window.paper = Raphael('canvas', $('div#canvas').offsetWidth, $('#canvas').offsetHeight);
    _ref = [$('button#parse'), $('textarea#user-input')], $parseButton = _ref[0], $inputArea = _ref[1];
    $parseButton.click(function() {
      return visualize($inputArea.val());
    });
    return $parseButton.trigger('click');
  });
}).call(this);
