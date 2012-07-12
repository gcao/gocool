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

