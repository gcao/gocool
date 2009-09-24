# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mark_required
    "<span class='required_field'>*</span>&nbsp;"
  end
  
  def show_flash container_class
    render :partial => 'shared/show_flash', :locals => {:container_class => container_class}
  end
end
