//= require head
$(document).ready(function(){

/// INITIALIZE THE BUBBLE
  head.js( "/assets/editor.js",
        function(){
            editor.init();
          });

/// AJAX PUT REQUEST
  var phrasables = document.querySelectorAll( '.phrasable' );
  
  for(var i = 0; i < phrasables.length; i++){
    phrasables[i].onblur = function(){

      var record = this
      
      var zenpenbubble = document.getElementById('zenpenbubble')

      setTimeout(function(){
        if(zenpenbubble.className.indexOf('active') < 0){
          savePhraseViaAjax(record.innerHTML, record.dataset["klass"], record.dataset["attribute"], record.dataset["id"])
        }
      }, 200)
    }
  }

  function savePhraseViaAjax(new_value, klass, attribute, id){
    $.ajax({
      type: "PUT",
      url: "/phrasing/remote_update_phrase",
      data: { klass: klass, attribute: attribute, id: id, new_value: new_value}
      }).done(function( msg ) {
        console.log("I've sent a ajax request:" + msg)
    });
  }


$('#edit-mode-onoffswitch').on('click', function(){
  alert("dadada");
});

});