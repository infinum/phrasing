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
  this.$saveButton       = options.$saveButton; 
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

    this.$saveButton.on('click', function(){
      if (Phrasing.isEditModeEnabled()){
        Phrasing.Bus.trigger('phrasing:handle-manual-save');
      }
    });
  },

  _alterStatus : function(text, color){
    this.$statusText.text(text);
    this.$statusIndicator.css('background-color', color);
  },

  _alterButton : function(text, color){
    this.$saveButton.text(text).css('background', color);
  },

  multiSave : function(){
    this._alterButton('Save All', 'orange');
  },

  dirty : function(){
    this._alterButton('Save', 'orange');
  },

  saving : function(){
    this._alterStatus('Saving', 'orange');
    this._alterButton('Saving', 'orange');
  },

  saved : function(){
    this._alterStatus('Saved', '#56AE45');
    this._alterButton('Save', '#56AE45');
  },

  error : function(){
    this._alterStatus('Error', 'red');
    this._alterButton('Save', 'red');
  }
};

var phrasing_setup = function(){
  var statusBubbleWidget = new StatusBubbleWidget({
    $statusText       : $('#phrasing-edit-mode-bubble #phrasing-saved-status-headline p'),
    $statusIndicator  : $('#phrasing-saved-status-indicator-circle'),
    $saveButton       : $('#phrasing-save button'),
    $editModeChechbox : $('#edit-mode-onoffswitch')
  });

  Phrasing.Bus.on('phrasing:edit-mode:on', function(){
    $('.phrasable').addClass("phrasable-on").attr("contenteditable", 'true');
    localStorage.setItem(Phrasing.EDIT_MODE_KEY, 'true');
  });

  Phrasing.Bus.on('phrasing:edit-mode:off', function(){
    $('.phrasable').removeClass("phrasable-on").attr("contenteditable", "false");
    localStorage.setItem(Phrasing.EDIT_MODE_KEY, "false");
  });

  Phrasing.Bus.on('phrasing:handle-manual-save', function(e){
    e.preventDefault();

    for (var key in changed_content) {
        savePhraseViaAjax(changed_content[key]);
        delete changed_content[key];
    }
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
  var changed_content = {};
  var timer = {};
  var timer_status = {};

  $('.phrasable').on('DOMNodeInserted DOMNodeRemoved DOMCharacterDataModified', function(e){
    if (userTriggeredPhrasingDOMChange === false){
      return;
    }

    var record = this;

    if(window.phrasingAutoSave){
      statusBubbleWidget.saving();
      clearTimeout(timer[$(record).data("url")]);
      timer_status[$(record).data("url")] = 0;

      timer[$(record).data("url")] = setTimeout(function(){
        savePhraseViaAjax(record);
        delete timer_status[$(record).data("url")];
      },2500);

      timer_status[$(record).data("url")] = 1;
    } else {
      changed_content[$(record).data("url")] = record;
      if (Object.keys(changed_content).length > 1) {
        statusBubbleWidget.multiSave();
      } else {
        statusBubbleWidget.dirty();
      }
    }
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

$(document).ready(phrasing_setup);

$(document).on('page:before-change', function() {
  Phrasing.Bus.off();
});
