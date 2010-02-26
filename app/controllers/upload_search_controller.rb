class UploadSearchController < ApplicationController
  def index
    if params[:op] == 'search'
      @uploads = Upload

      @username = params[:username].try(:strip)
      @uploads = @uploads.uploader_is(@username) unless @username.blank?
      
      @description = params[:description]
      @uploads = @uploads.with_description(@description) unless @description.blank? 

      @from_date = params[:from_date]
      @to_date = params[:to_date]
      from = Date.parse @from_date unless @from_date.blank?
      to = Date.parse @to_date unless @to_date.blank?
      if from and to and from > to
        flash.now[:error] = t("upload_search.from_date_greater_than_to_date")
        @uploads = nil
      else
        @uploads = @uploads.between(from, to)
      end
    end
  end
end
