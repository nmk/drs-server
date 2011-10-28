displayJSON = (data, target) ->
  try
    $('div#message').hide()
    result = drsParser.parse data, 'drs'
    resultRepresentation = JSON.stringify result, null, '  '
    target.html $('<pre/>').html(resultRepresentation)
  catch error
    $('div#message').html(error.message).show()

$(document).ready ->
  [ $parseButton, $visualizeButton, $inputArea, $outputArea ] =
    [ $('button#parse'), $('button#visualize'), $('textarea#user-input'), $('div#json-output') ]

  $parseButton.click (event) ->
    event.preventDefault()
    displayJSON $inputArea.val(), $outputArea

  $visualizeButton.click (event) ->
    event.preventDefault()
    $.post "/drs/visualize",
      data: $inputArea.val()
    , (data) ->
      console.log data

  $parseButton.trigger 'click'
