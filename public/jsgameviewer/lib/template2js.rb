def template2js game_type, locale
  template_file = "view/templates/#{game_type}_#{locale}.html"
  js_file = "view/templates/#{game_type}_#{locale}.js"
  js_var_shared = "#{game_type.upcase}_TEMPLATE"
  js_var = "#{game_type.upcase}_TEMPLATE_#{locale}"
  
  template = IO.readlines(template_file).map{|line| line.strip}.join
  template.gsub!('"', "'")
  template.gsub!('/jsgameviewer', 'http://localhost/jsgameviewer')
  File.open(js_file, 'w') do |f|
    f.print("jsGameViewer.#{js_var} = \"#{template}\";\n")
    f.print("jsGameViewer.#{js_var_shared} = jsGameViewer.#{js_var};\n")
  end
end