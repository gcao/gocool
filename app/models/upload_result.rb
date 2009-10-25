class UploadResult
  attr_accessor :upload, :status, :detail, :existing_upload
  
  def initialize attrs = {}
    attrs.each do |key, value|
      method = :"#{key}="
      self.send(method, value) if self.respond_to? method
    end
  end
end