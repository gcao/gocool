class Responder
  def initialiaze template
    @template = template
    @children = {}
  end
  
  def to_s
    compiled_template.render binding
  end
  
  def render child
    @children[child].to_s
  end

  def render_template template_name
    template = Haml::Engine.new(File.read(File.expand_path(File.dirname(__FILE__) + "templates/#{template_name}.haml")))
    template.render binding
  end
  
  private
  
  def compiled_template
    @compiled_template ||= Haml::Engine.new(File.read(File.expand_path(File.dirname(__FILE__) + "templates/#{template}.haml")))
  end
end
