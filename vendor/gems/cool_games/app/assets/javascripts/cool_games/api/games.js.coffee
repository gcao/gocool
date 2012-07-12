window.initApiGames = (page) ->
  $('#games_search_form').bind 'ajax:success', (event, response) ->
    console.log "#games_search_form is submitted"
    console.log response

    # Reset page number hidden field
    $('#games_search_form input[name=page]').val(1)

    switch response.status
      when 'success'
        showGames(response.body)
        paginate '#games_table .pagination', response.pagination, (page) ->
          console.log "Page #{page}"
          $('#games_search_form input[name=page]').val(page)
          $('#games_search_form input[type=submit]').click()
          true

      when 'validation_error'
        $('#games_not_found').hide()
        $('#games_table').hide()
        for error in response.errors
          showError(error.field, error.message)

  loadGames(page)

loadGames = (page) ->
  url = urls.api.games + ".json"
  url = url + "?page=#{page}" if page
  $.ajax url,
    dataType: 'jsonp'
    crossDomain: true
    success: (response) ->
      console.log url
      console.log response

      if response.status == 'not_authenticated'
        window.location = urls.api.login
        return

      showGames(response.body)
      paginate '#games_table .pagination', response.pagination, (page) ->
        console.log "Page #{page}"
        loadGames(page)
        true

showGames = (games) ->
  if games && games.length > 0
    $('#games_not_found').hide()
    $('#games_table').show()
    $('#games_table tbody').html('')
    for game in games
      $('#games_table tbody').append """
        <tr>
          <td>#{[game.id]}</td>
          <td>#{[game.name]}</td>
          <td>#{[game.black_name]}</td>
          <td>#{[game.white_name]}</td>
          <td>#{[game.handicap]}</td>
          <td>#{[game.komi]}</td>
          <td>#{[game.moves]}</td>
          <td>#{[game.result]}</td>
          <td>#{[game.played_at]}</td>
          <td>#{[game.place]}</td>
          <td>#{[game.description]}</td>
          <td><a href='#{[game.url]}'>欣赏</a></td>
        </tr>
      """
  else
    $('#games_not_found').show()
    $('#games_table').hide()

