class UsersController < ApplicationController
  def my_uploads
    @page_title = t('shared.page_title') + " - " + t('my_uploads.page_title')
    @uploads = Upload.recent.find_all_by_uploader_id(@user.id)
  end

  def my_favorites
  end
end
