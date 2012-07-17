window.loadGames = (page) ->
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

gameNameTmpl = tmpl """
  Game <%= id %>:
  <%= black_name %><% if (black_rank) { %>(<%= black_rank %>) <% } %>
  vs
  <%= white_name %><% if (white_rank) { %>(<%= white_rank %>) <% } %>
"""

window.showGame = (game, user) ->
  $('.content h3').html(gameNameTmpl(game))

  window.gameState = game.state
  gameType = jsGameViewer.WEIQI
  controller = new GameController({gameType: gameType, container: "gameContainer"})

  if user == game.black_name || user == game.white_name
    controller.createGocoolPlayer().loadGocoolGame(game.id)
  else
    url = urls.games + '/' + game.id + '.sgf'
    controller.load(url)

