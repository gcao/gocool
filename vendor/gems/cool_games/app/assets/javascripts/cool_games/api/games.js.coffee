window.initApiGames = (games_url) ->
  #$.getJSON games_url, (response) ->
  #  console.log response
  $.ajax games_url,
    dataType: 'jsonp'
    crossDomain: true
    success: (response) ->
      console.log response
      games = response.body
      if games
        $('#games_not_found').hide()
        $('#games_table').show()
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

