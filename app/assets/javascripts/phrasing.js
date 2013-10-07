//= require head
//= require spin
$(document).ready(function(){

/// INITIALIZE THE BUBBLE
  head.js( "/assets/editor.js",
        function(){
            editor.init();
          });

// SPINNER
  var opts = {
    lines: 9, // The number of lines to draw
    length: 0, // The length of each line
    width: 7, // The line thickness
    radius: 12, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    direction: 1, // 1: clockwise, -1: counterclockwise
    color: '#FFF', // #rgb or #rrggbb or array of colors
    speed: 1.9, // Rounds per second
    trail: 58, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: 'auto', // Top position relative to parent in px
    left: 'auto' // Left position relative to parent in px
  };

  var target = document.getElementById('phrasing-spinner');
  var spinner = new Spinner(opts).spin(target);
  spinner.stop();

///ON TEXTCHANGE TRIGGER AJAX
  var phrasable_trigger_binded_events_flag = 1;
  var timer = {}

  $('.phrasable').on('DOMNodeInserted DOMNodeRemoved DOMCharacterDataModified', function(e){
    
    if (phrasable_trigger_binded_events_flag == 1){
      var record = this;
  
      clearTimeout(timer[record.dataset["url"]]);

      timer[$(record).data("url")] = setTimeout(function(){
        savePhraseViaAjax(record.innerHTML, record.dataset["url"]);
      },2500)
    }

  });

///AJAX REQUEST
  function savePhraseViaAjax(new_value, url){
    $.ajax({
      type: "PUT",
      url: url,
      data: { new_value: new_value },
      beforeSend: function(){
        spinner.spin(target);
      },
      success: function(e){
        spinner.stop();
        console.log("I've sent a ajax request: " + new_value);
        phrasable_trigger_binded_events_flag = 0;
        $('span.phrasable[data-url="'+ url+'"]').html(new_value)
        phrasable_trigger_binded_events_flag = 1;
      }})
  }

/// EDIT MODE SWITCH MODE BUTTON
  $('#edit-mode-onoffswitch').on('change', function(){
    if(this.checked){
        $('.phrasable').addClass("phrasable_on").attr("contenteditable", "true");
        $.cookie("editing_mode", "true");
    }
    else{
        $('.phrasable').removeClass("phrasable_on").attr("contenteditable", "false");
        $.cookie("editing_mode", "false");
    }
  });


  if($.cookie("editing_mode") == "true"){
    $('#edit-mode-onoffswitch').prop('checked', true)
  }else{
    $('#edit-mode-onoffswitch').prop('checked', false)
  }








});