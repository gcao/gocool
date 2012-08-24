window.loadInvitations = ->
  url = urls.api.invitations + ".json"
  url = addAuthToUrl(url)
  $.ajax url,
    dataType: 'jsonp'
    crossDomain: true
    success: (response) ->
      handleResponse response,
        before: -> console.log url
        callback: -> showInvitations(response.body)

showInvitations = (invitations) ->
  if invitations && invitations.length > 0
    $('#invitations_to_me_container').show()
    for invitation in invitations
      $('#invitations_to_me_container table tbody').append """
        <tr>
          <td>#{[invitation.created_at]}</td>
          <td>#{[invitation.state]}</td>
          <td>#{[invitation.game_type]}</td>
          <td>#{[invitation.inviter]}</td>
          <td>#{[invitation.start_side]}</td>
          <td>#{[invitation.handicap]}</td>
          <td>#{[invitation.note]}</td>
          <td>#{[invitation.played_at]}</td>
          <td><a href='#{[urls.api.invitations + "/" + invitation.id + ".html"]}'>欣赏</a></td>
        </tr>
      """
  else
    $('#invitations_to_me_container').hide()
