window.loadPlayers = (page) ->
  url = gon.urls.api.players + ".json"
  url = url + "?page=#{page}" if page
  $.ajax url,
    dataType: 'jsonp'
    crossDomain: true
    success: (response) ->
      handleResponse response,
        before: -> console.log url
        callback: -> showPlayers(response.body)
        pagination:
          container: '#players_table .pagination'
          callback: (page) -> loadPlayers(page)

window.showPlayers = (players) ->
  if players && players.length > 0
    $('#players_not_found').hide()
    $('#players_table').show()
    $('#players_table tbody').html('')
    for player in players
      $('#players_table tbody').append """
        <tr>
          <td>#{[player.name]}</td>
          <td>#{[player.rank]}</td>
          <td><a href='#{[gon.urls.api.invitations + "/new?invitees=" + player.name]}'>对局邀请</a></td>
        </tr>
      """
  else
    $('#players_not_found').show()
    $('#players_table').hide()
