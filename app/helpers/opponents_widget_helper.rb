module OpponentsWidgetHelper
  def render_opponents_widget opponents
    return unless opponents

    @opponents_for_widget = opponents.paginate page_params(:opponents_page)
    render :partial => 'opponents_widget/opponents'
  end
end
