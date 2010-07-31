class ApplicationResponder < BaseResponder
  include ActionView::Helpers
  include ApplicationHelper
  include GamesWidgetHelper
  
  def initialize template = nil
    super(template || "layouts/application.html")
    @children[:title] = "TITLE TODO"
    @children[:body] = "BODY TODO"
    @children[:footer] = "FOOTER TODO"
  end
end
