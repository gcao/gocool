window.initApiGames = ->
  $('#games_search_form').bind 'ajax:success', (event, response) ->
    console.log response
    switch response.status
      when 'success'
        showGames(response.body)
      when 'validation_error'
        $('#games_not_found').hide()
        $('#games_table').hide()
        for error in response.errors
          showError(error.field, error.message)

  $.ajax urls.api.games,
    dataType: 'jsonp'
    crossDomain: true
    success: (response) ->
      console.log response

      if response.status == 'not_authenticated'
        window.location = '/users/sign_in'
        return

      showGames(response.body)
      paginate('#games_table .pagination', response.pagination)

window.showGames = (games) ->
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

window.paginate = (container, pagination) ->
  if pagination
    $(container).show().jillpaginate
      totalPages: pagination.total_pages
      currentPage: pagination.page
  else
    $(container).hide()
