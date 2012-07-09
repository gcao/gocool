window.initApiSessions = ->
  $('#login_form').bind 'ajax:success', (event, response) ->
    console.log response
    switch response.status
      when 'success'
        window.location = urls.api.games
      when 'login_failure'
        for error in response.errors
          showError(error.field, error.message)

