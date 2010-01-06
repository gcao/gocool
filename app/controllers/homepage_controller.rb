class HomepageController < ApplicationController
  def index
    @recent_uploads = Upload.recent.paginate(page_params)
  end
end
