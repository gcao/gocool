module UploadsWidgetHelper
  def render_uploads_widget uploads
    return unless uploads

    @uploads_for_widget = uploads
    render :partial => 'uploads_widget/uploads'
  end
end
