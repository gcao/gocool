window.initApiGames = (games_url) ->
  jQuery.getJSON games_url, (response) ->
    console.log response
    if response.games
      jQuery('#games_not_found').hide()
      jQuery('#games_table').show()
      for game in response.games
        jQuery('#games_table tbody').append """
          <tr>
            <td>#{game.id}</td>
            <td>#{game.name}</td>
            <td>#{game.black_name}</td>
            <td>#{game.white_name}</td>
            <td>#{game.handicap}</td>
            <td>#{game.komi}</td>
            <td>#{game.moves}</td>
            <td>#{game.result}</td>
            <td>#{game.played_at}</td>
            <td>#{game.place}</td>
            <td>#{game.description}</td>
            <td><a href='#{game.url}'>欣赏</a></td>
          </tr>
        """
    else
      jQuery('#games_not_found').show()
      jQuery('#games_table').hide()

