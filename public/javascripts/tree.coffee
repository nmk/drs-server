labelStyle =
  'font-size': 16
  'font-family': "'Hoefler Text', serif"

partStyle =
  'font-size': 16
  'font-family': "'Hoefler Text', serif"
  'font-style': 'italic'

treeWidth = (tree) ->
  if tree.part
    Math.max(tree.label.getBBox().width,
             tree.part.getBBox().width,
             _(tree.subTrees || []).map((t) -> treeWidth(t)).reduce(((o, n) -> o + n), 0))
  else
    Math.max(tree.label.getBBox().width,
             _(tree.subTrees || []).map((t) -> treeWidth(t)).reduce(((o, n) -> o + n), 0))

drawEdge = (paper, start, end) ->
  [ startBBox, endBBox ] = [ start.label.getBBox(), end.label.getBBox() ]

  startY = startBBox.y + startBBox.height + 4

  if start.part
    startY += start.part.getBBox().height + 4

  pathDef = "M#{startBBox.x + startBBox.width / 2}, #{startY} \
             L#{endBBox.x + endBBox.width / 2}, #{endBBox.y - 4}"

  paper.path(pathDef)

moveTree = (paper, tree, x, y) ->

  tree.label.translate x, y

  if tree.part
    tree.part.translate x, y

  for edge in tree.edges
    edge.remove()

  tree.edges = []

  for subTree in tree.subTrees
    movedTree = moveTree(paper, subTree, x, y)
    tree.edges.push(drawEdge(paper, tree, movedTree))

  tree

drawTree = (paper, treeDef, level=0) ->

  label = paper.text(0, 0, treeDef.label).attr labelStyle

  if treeDef.part
    part = paper.text(0, label.getBBox().height + 5, treeDef.part).attr partStyle

  subTrees = (drawTree(paper, child, level + 1) for child in (treeDef.child_nodes || []))
  widthOfAllSubTrees = _(subTrees).map((t) -> treeWidth(t)).reduce(((o, n) -> o + n), 0)

  vertOffsetForNextLevel = 35 + label.getBBox().height
  if part
    vertOffsetForNextLevel += part.getBBox().height + 20

  if subTrees.length == 1
    moveTree(paper, subTrees[0], 0, 50)
  else
    for subTree, index in subTrees
      moveTree(paper, subTree,
               index * widthOfAllSubTrees - widthOfAllSubTrees / (subTrees.length),
               vertOffsetForNextLevel)

  { label: label, part: part, subTrees: subTrees, edges: [] }

visualize = (data) ->
  if window.paper
    window.paper.clear()
  else
    window.paper = Raphael 'canvas'

  $('div#message').hide()

  try
    result = treeParser.parse(data)
    drawnTree = drawTree(paper, result)
    moveTree(window.paper, drawnTree, Math.round(window.paper.width / 2), 20)
  catch error
    $('div#message').html(error.message).show()

$(document).ready ->
  window.paper = Raphael 'canvas', $('div#canvas').offsetWidth, $('#canvas').offsetHeight
  [ $parseButton, $inputArea ] = [ $('button#parse'), $('textarea#user-input') ]
  $parseButton.click ->
    visualize $inputArea.val()
  $parseButton.trigger 'click'
