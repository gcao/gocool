window.loadInvitations = ->
  url = gon.urls.api.invitations + ".json"
  url = addAuthToUrl(url)
  $.ajax url,
    dataType   : 'jsonp'
    crossDomain: true
    success    : (response) ->
      handleResponse response,
        before  : -> console.log url
        callback: -> showInvitations(response.body)

invitationRowTmpl = tmpl """
  <tr>
    <td><%= invitation.created_at %></td>
    <td><%= invitation.state %></td>
    <td><%= invitation.game_type_str %></td>
    <td><%= invitation.inviter.name %></td>
    <td><%= invitation.invitee.name %></td>
    <td><%= invitation.start_side_str %></td>
    <td><%= invitation.handicap_str %></td>
    <td><%= invitation.note %></td>
    <td>
      <% if (invitation.is_inviter) { %>
      <a href=\'javascript:cancelInvitation("<%= invitation.id %>")\'>取消</a>
      <% } else { %>
      <a href=\'javascript:acceptInvitation("<%= invitation.id %>")\'>接受</a>
      <a href=\'javascript:rejectInvitation("<%= invitation.id %>")\'>拒绝</a>
      <% } %>
    </td>
  </tr>
"""

showInvitations = (invitations) ->
  if invitations && invitations.length > 0
    $('#invitations_container').show()
    for invitation in invitations
      $('#invitations_container table tbody').append invitationRowTmpl {invitation: invitation}
  else
    $('#invitations_container').hide()

window.cancelInvitation = (id) ->
  url = gon.urls.api.invitations + "/#{id}/cancel.json"
  url = addAuthToUrl(url)
  $.ajax url,
    dataType   : 'jsonp'
    crossDomain: true
    success    : (response) ->
      handleResponse response,
        before  : -> console.log url
        callback: -> window.location = gon.urls.api.invitations

window.acceptInvitation = (id) ->
  url = gon.urls.api.invitations + "/#{id}/accept.json"
  url = addAuthToUrl(url)
  $.ajax url,
    dataType   : 'jsonp'
    crossDomain: true
    success    : (response) ->
      handleResponse response,
        before  : -> console.log url
        callback: -> window.location = gon.urls.api.games + "/" + response.body.game_id

window.rejectInvitation = (id) ->
  url = gon.urls.api.invitations + "/#{id}/reject.json"
  url = addAuthToUrl(url)
  $.ajax url,
    dataType   : 'jsonp'
    crossDomain: true
    success    : (response) ->
      handleResponse response,
        before  : -> console.log url
        callback: -> window.location = gon.urls.api.invitations

