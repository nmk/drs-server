(function() {
  var displayJSON;
  displayJSON = function(data, target) {
    var result, resultRepresentation;
    try {
      $('div#message').hide();
      result = drsParser.parse(data, 'drs');
      resultRepresentation = JSON.stringify(result, null, '  ');
      return target.html($('<pre/>').html(resultRepresentation));
    } catch (error) {
      return $('div#message').html(error.message).show();
    }
  };
  $(document).ready(function() {
    var $inputArea, $outputArea, $parseButton, $visualizeButton, _ref;
    _ref = [$('button#parse'), $('button#visualize'), $('textarea#user-input'), $('div#json-output')], $parseButton = _ref[0], $visualizeButton = _ref[1], $inputArea = _ref[2], $outputArea = _ref[3];
    $parseButton.click(function(event) {
      event.preventDefault();
      return displayJSON($inputArea.val(), $outputArea);
    });
    $visualizeButton.click(function(event) {
      event.preventDefault();
      return $.post("/drs/visualize", {
        data: $inputArea.val()
      }, function(data) {
        return console.log(data);
      });
    });
    return $parseButton.trigger('click');
  });
}).call(this);
