class UploadSearchController < ApplicationController
  def index
    if search_by_description?
      @description = params[:description].try(:strip)
      @uploads = Upload.with_description(@description).paginate(page_params)
    elsif search_by_date?
      @from_date = params[:from_date]
      @to_date = params[:to_date]
      from = Date.parse @from_date unless @from_date.blank?
      to = Date.parse @to_date unless @to_date.blank?
      if from and to and from > to
        flash[:error] = t("upload_search.from_date_greater_than_to_date")
      else
        @uploads = Upload.between(from, to).paginate(page_params)
      end
    end
  end

  def search_by_description?
    params[:search_type] == 'description'
  end

  def search_by_date?
    params[:search_type] == 'date'
  end
  
  helper_method :search_by_description?, :search_by_date?
end
