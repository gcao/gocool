#= require_self
#= require cool_games/api/games
#= require cool_games/api/invitations

window.paginate = (container, pagination, pageHandler) ->
  if pagination and pagination.total_pages > 1
    $(container).jillpaginate('destroy').jillpaginate
      totalPages: pagination.total_pages
      currentPage: pagination.page
      page: pageHandler
    .show()

  else
    $(container).hide()

window.handleResponse = (response, options = {}) ->
  options.before? response

  console.log response

  if response.status == 'not_authenticated'
    window.location = gon.urls.api.login
    return

  options.callback? response

  if options.pagination
    paginate options.pagination.container, response.pagination, (page) ->
      console.log "Page #{page}"
      options.pagination.callback(page)
      true

window.addAuthToUrl = (url) ->
  return url unless gon.auth_token
  url += if url.indexOf('?') >= 0 then '&' else '?'
  url += "auth_token=" + gon.auth_token

