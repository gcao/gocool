module CoolGames
  module UrlsHelper
    def url_for_uploads_of_today
      url_for(:controller => :upload_search, :action => :index, :op => 'search', :from_date => Date.today)
    end

    def url_for_uploads_of_7_days
      url_for(:controller => :upload_search, :action => :index, :op => 'search', :from_date => Date.today - 6.days)
    end
  end
end
