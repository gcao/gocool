window.initApiGames = (page) ->
  $('#games_search_form').bind 'ajax:success', (event, response) ->
    handleResponse response,
      before: -> console.log "#games_search_form is submitted" 

      callback: (response) ->
        # Reset page number hidden field
        $('#games_search_form input[name=page]').val(1)

        switch response.status
          when 'success'
            showGames(response.body)

          when 'validation_error'
            $('#games_not_found').hide()
            $('#games_table').hide()
            for error in response.errors
              showError(error.field, error.message)

      pagination:
        container: '#games_table .pagination'
        callback: (page) ->
          $('#games_search_form input[name=page]').val(page)
          $('#games_search_form input[type=submit]').click()

  loadGames(page)

loadGames = (page) ->
  url = urls.api.games + ".json"
  url = url + "?page=#{page}" if page
  $.ajax url,
    dataType: 'jsonp'
    crossDomain: true
    success: (response) ->
      handleResponse response,
        before: -> console.log url
        callback: -> showGames(response.body)
        pagination:
          container: '#games_table .pagination'
          callback: (page) -> loadGames(page)

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
          <td><a href='#{[urls.api.games + "/" + game.id + ".html"]}'>欣赏</a></td>
        </tr>
      """
  else
    $('#games_not_found').show()
    $('#games_table').hide()

window.showGame = (game, user) ->
  $('.content h3').replaceWith(tmpl('game_name_tmpl', game))

  window.gameState = game.state
  gameType = jsGameViewer.WEIQI
  controller = new GameController({gameType: gameType, container: "gameContainer"})

  if user == game.black_name || user == game.white_name
    controller.createGocoolPlayer().loadGocoolGame(game.id)
  else
    url = urls.games + '/' + game.id + '.sgf'
    #controller.load(url)

