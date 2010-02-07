module ObjectExtension
  def nil_or
    return self unless self.nil?
    Class.new do
      def method_missing(sym, *args); nil; end
    end.new
  end

  def not_nil?
    !self.nil?
  end

  def not_blank?
    !self.blank?
  end
end

Object.send :include, ObjectExtension
