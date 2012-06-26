module CoolGames
  module PaginationHelper
    def page_params page_no_param = :page
      page_size = (ENV['ROWS_PER_PAGE'] || 15).to_i
      { :per_page => page_size, :page => params[page_no_param] }
    end
  end
end

