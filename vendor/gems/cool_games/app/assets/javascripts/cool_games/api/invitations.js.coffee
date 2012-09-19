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
    <td>
      <% if (invitation.state == "new") { %>等待被邀请人回应
      <% } else if (invitation.state == "changed_by_invitee") { %>被邀请人修改了设置，等待邀请人回应
      <% } else if (invitation.state == "changed_by_inviter") { %>邀请人修改了设置，等待被邀请人回应
      <% } %>
    </td>
    <td><%= invitation.game_type_str %></td>
    <td><%= invitation.inviter.name %></td>
    <td><%= invitation.invitee.name %></td>
    <td><%= invitation.start_side_str %></td>
    <td><%= invitation.handicap_str %></td>
    <td><%= invitation.note %></td>
    <td>
      <% if (invitation.is_inviter) { %>
        <% if (invitation.state == "changed_by_invitee") { %>
          <a href=\'javascript:acceptInvitation("<%= invitation.id %>")\'>接受</a>
        <% } %>
        <a href=\'#{gon.urls.api.invitations}/<%= invitation.id %>/edit\'>修改设置</a>
        <a href=\'javascript:cancelInvitation("<%= invitation.id %>")\'>取消</a>
      <% } %>
      <% if (invitation.is_invitee) { %>
        <% if (["new", "changed_by_inviter"].indexOf(invitation.state) >= 0) { %>
          <a href=\'javascript:acceptInvitation("<%= invitation.id %>")\'>接受</a>
        <% } %>
        <a href=\'javascript:rejectInvitation("<%= invitation.id %>")\'>拒绝邀请</a>
        <a href=\'#{gon.urls.api.invitations}/<%= invitation.id %>/edit\'>修改设置</a>
      <% } %>
    </td>
  </tr>
"""

showInvitations = (invitations) ->
  if invitations && invitations.length > 0
    $('#invitations_container').show()
    for invitation in invitations
      $('#invitations_container table tbody').append invitationRowTmpl(invitation: invitation)
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

