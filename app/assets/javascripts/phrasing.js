//= require editor

var Phrasing = {
  Bus : $({}),
  EDIT_MODE_KEY : 'editing-mode'
};

Phrasing.isEditModeEnabled = function(){
  return localStorage.getItem(this.EDIT_MODE_KEY) === "true";
};

function StatusBubbleWidget(options){
  this.$statusText       = options.$statusText;
  this.$statusIndicator  = options.$statusIndicator;
  this.$editModeChechbox = options.$editModeChechbox;
  this._init();
}

StatusBubbleWidget.prototype = {
  _init : function(){
    this.$editModeChechbox.on('change', function(){
      if(this.checked){
        Phrasing.Bus.trigger('phrasing:edit-mode:on');
      }else{
        Phrasing.Bus.trigger('phrasing:edit-mode:off');
      }
    });
  },

  _alterStatus : function(text, color){
    this.$statusText.text(text);
    this.$statusIndicator.css('background-color', color);
  },

  saving : function(){
    this._alterStatus('Saving', 'orange');
  },

  saved : function(){
    this._alterStatus('Saved', '#56AE45');
  },

  error : function(){
    this._alterStatus('Error', 'red');
  }
};

var phrasing_setup = function(){
  var statusBubbleWidget = new StatusBubbleWidget({
    $statusText       : $('#phrasing-edit-mode-bubble #phrasing-saved-status-headline p'),
    $statusIndicator  : $('#phrasing-saved-status-indicator-circle'),
    $editModeChechbox : $('#edit-mode-onoffswitch')
  });

  Phrasing.Bus.on('phrasing:edit-mode:on', function(){
    $('.phrasable').addClass("phrasable-on").attr("contenteditable", 'true');
    localStorage.setItem(Phrasing.EDIT_MODE_KEY, 'true');
    disable_links();
  });

  Phrasing.Bus.on('phrasing:edit-mode:off', function(){
    $('.phrasable').removeClass("phrasable-on").attr("contenteditable", "false");
    localStorage.setItem(Phrasing.EDIT_MODE_KEY, "false");
    enable_links();
  });

  // Initialize the editing bubble
  editor.init();

  // Making sure to send csrf token from layout file.
  $(document).ajaxSend(function(e, xhr, options) {
    var token = $("meta[name='csrf-token']").attr("content");
    xhr.setRequestHeader("X-CSRF-Token", token);
  });

  // Hash size function
  Object.size = function(obj){
    var size = 0, key;
    for (key in obj) { if (obj.hasOwnProperty(key)) size++; }
    return size;
  };

  // Trigger AJAX on textchange
  var userTriggeredPhrasingDOMChange = true;
  var timer = {};
  var timer_status = {};

  $('.phrasable').on('DOMNodeInserted DOMNodeRemoved DOMCharacterDataModified', function(e){
    if (userTriggeredPhrasingDOMChange === false){
      return;
    }

    statusBubbleWidget.saving();

    var record = this;

    clearTimeout(timer[$(record).data("url")]);
    timer_status[$(record).data("url")] = 0;

    timer[$(record).data("url")] = setTimeout(function(){
      savePhraseViaAjax(record);
      delete timer_status[$(record).data("url")];
    },2500);

    timer_status[$(record).data("url")] = 1;
  });

  // AJAX Request
  function savePhraseViaAjax(record){

    var url = $(record).data("url");

    var content = record.innerHTML;

    if(content.length === 0){
      content = "Empty";
    }

    $.ajax({
      type: "PUT",
      url: url,
      data: { new_value: content },
      success: function(e){
        userTriggeredPhrasingDOMChange = false;
        if(content === "Empty"){
          $('span.phrasable[data-url="'+ url +'"]').html(content);
        }else{
          // Not to lose the cursor on the current contenteditable element
          $('span.phrasable[data-url="'+ url +'"]').not(record).html(content);
        }
        userTriggeredPhrasingDOMChange = true;

        if (Object.size(timer_status) === 0){
          statusBubbleWidget.saved();
        }
      },
      error: function(e){
        statusBubbleWidget.error();
      }
    });
  }

  if(localStorage.getItem(Phrasing.EDIT_MODE_KEY) === undefined){
    localStorage.setItem(Phrasing.EDIT_MODE_KEY, 'true');
  }

  if(localStorage.getItem(Phrasing.EDIT_MODE_KEY) == 'true'){
    $('#edit-mode-onoffswitch').prop('checked', true).change();
  }else{
    $('#edit-mode-onoffswitch').prop('checked', false).change();
  }

};

function disable_links() {
  $('a').on("click.phrasing", function(e){
    if($(this).find('span').hasClass('phrasable')) {
      e.preventDefault();
    }
  });
}

function enable_links() {
  $('a').off('click.phrasing')
}

$(document).ready(phrasing_setup);

$(document).on('page:before-change', function() {
  Phrasing.Bus.off();
});
