#= require_self
#= require cool_games/api/games

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
  if options.before
    options.before(response)

  console.log response

  if response.status == 'not_authenticated'
    window.location = urls.api.login
    return

  if options.callback
    options.callback(response)

  if options.pagination
    paginate options.pagination.container, response.pagination, (page) ->
      console.log "Page #{page}"
      options.pagination.callback(page) 
      true

