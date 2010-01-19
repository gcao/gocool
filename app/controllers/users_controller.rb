class UsersController < ApplicationController
  def my_uploads
    @uploads = Upload.find_all_by_uploader_id(@user.id).paginate(page_params)
  end

  def my_favorites
  end
end
