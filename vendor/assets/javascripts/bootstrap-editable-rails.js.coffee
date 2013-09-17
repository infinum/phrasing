# bootstrap-editable-rails.js.coffee
# Modify parameters of X-editable suitable for Rails.

jQuery ($) ->
  # getURLParameter = (name, url) -> 
  #   return decodeURIComponent((new RegExp("[?|&]#{name}=([^&;]+?)(&|##|;|$)").exec(url) || [null,""] )[1].replace(/\+/g, '%20'))||null; 

  EditableForm = $.fn.editableform.Constructor
  EditableForm.prototype.saveWithUrlHook = (value) ->
    originalUrl = @options.url
    resource = @options.resource
    @options.url = (params) =>
      # TODO: should not send when create new object
      if typeof originalUrl == 'function' # user's function
        originalUrl.call(@options.scope, params)
      else if originalUrl? && @options.send != 'never'
        # send ajax to server and return deferred object
        obj = {}
        obj[params.name] = params.value
        # support custom inputtypes (eg address)
        if resource
          params[resource] = obj
        else
          params = obj
        delete params.name
        delete params.value
        delete params.pk
        $.ajax($.extend({
          url     : originalUrl
          data    : params
          type    : 'PUT' # TODO: should be 'POST' when create new object
          dataType: 'json'
          success: ->
            # klass = getURLParameter("class", originalUrl) || "copycat_translation";
            # attribute = getURLParameter("attribute", originalUrl) || "value";
            $("span").find("[data-url='" + originalUrl + "']").text(params["new_value"]);
        }, @options.ajaxOptions))
    @saveWithoutUrlHook(value)
  EditableForm.prototype.saveWithoutUrlHook = EditableForm.prototype.save
  EditableForm.prototype.save = EditableForm.prototype.saveWithUrlHook