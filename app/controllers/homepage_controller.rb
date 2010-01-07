class HomepageController < ApplicationController
  def index
    @uploads = Upload.recent.paginate(page_params)
  end
end
