class ApplicationResponder < Responder
  include ActionView::Helpers
  include ApplicationHelper
  
  def initialize
    super "layouts/application.html"
    @children[:title] = "TITLE TODO"
    @children[:body] = "BODY TODO"
    @children[:footer] = "FOOTER TODO"
  end
end
