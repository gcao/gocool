module UploadsWidgetHelper
  def render_uploads_widget uploads
    render :partial => 'uploads_widget/uploads', :locals => {:uploads => uploads} if uploads
  end
end
