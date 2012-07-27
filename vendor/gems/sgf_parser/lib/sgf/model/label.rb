class SGF::Model::Label
  attr_accessor :position, :text
  
  def initialize position, text
    self.position = position
    self.text     = text
  end
  
  def == other
    self.position == other.position and self.text == other.text
  end
end
