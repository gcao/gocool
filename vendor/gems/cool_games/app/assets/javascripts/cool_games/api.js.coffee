#= require_self
#= require cool_games/api/games

window.paginate = (container, pagination, pageHandler) ->
  if pagination
    $(container).show().jillpaginate
      totalPages: pagination.total_pages
      currentPage: pagination.page
      page: pageHandler
  else
    $(container).hide()

