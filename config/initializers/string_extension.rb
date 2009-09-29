String.class_eval do
  # This will allow debug statements like 'puts response.body.escape_markup' to output html/xml content nicely
  def escape_markup
    gsub('<', '&lt;').gsub("\n", "<br/>")
  end
  
  alias esm escape_markup
end