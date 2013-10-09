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

// Hash size function

Object.size = function(obj) {
    var size = 0, key;
    for (key in obj) {
        if (obj.hasOwnProperty(key)) size++;
    }
    return size;
};



///ON TEXTCHANGE TRIGGER AJAX
  var trigger_binded_events_for_phrasable_class = 1;
  var timer = {}
  var timer_status = {}

  $('.phrasable').on('DOMNodeInserted DOMNodeRemoved DOMCharacterDataModified', function(e){

    $('#phrasing-edit-mode-bubble #phrasing-spinner p').css("color", "red").text("Currently editing..")
    
    if (trigger_binded_events_for_phrasable_class == 1){

      var record = this;

      // console.log(timer)
      
      clearTimeout(timer[$(record).data("url")]);
      timer_status[$(record).data("url")] = 0;
      
      timer[$(record).data("url")] = setTimeout(function(){
        savePhraseViaAjax(record);
        delete timer_status[$(record).data("url")]
      },2500)
      timer_status[$(record).data("url")] = 1;
    }

  });

///AJAX REQUEST
  function savePhraseViaAjax(record){
    var url = $(record).data("url");
    var content = record.innerHTML;
    $.ajax({
      type: "PUT",
      url: url,
      data: { new_value: content },
      beforeSend: function(){
        spinner.spin(target);
      },
      success: function(e){
        spinner.stop();
        console.log("I've sent a ajax request: " + content);

        trigger_binded_events_for_phrasable_class = 0;
        $('span.phrasable[data-url="'+ url +'"]').not(record).html(content)
        trigger_binded_events_for_phrasable_class = 1;
        if (Object.size(timer_status) == 0){
          $('#phrasing-edit-mode-bubble #phrasing-spinner p').css("color", "green").text("Everything saved.")
        }
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

  if($.cookie("editing_mode") == null){
    $.cookie("editing_mode", "true");
    $('#edit-mode-onoffswitch').prop('checked', true)
  }
  else if($.cookie("editing_mode") == "true"){
    $('#edit-mode-onoffswitch').prop('checked', true)
  }else{
    $('#edit-mode-onoffswitch').prop('checked', false)
  }








});