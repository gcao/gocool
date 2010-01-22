module UploadsWidgetHelper
  def render_uploads_widget uploads
    return unless uploads

    @uploads_for_widget = uploads.paginate page_params(:uploads_page)
    render :partial => 'uploads_widget/uploads'
  end
end
