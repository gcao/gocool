module ObjectExtension
  class NilOr
    def method_missing(sym, *args);
      nil
    end
  end

  def nil_or
    return self unless self.nil?
    NilOr.new
  end

  def not_nil?
    !self.nil?
  end

  def not_blank?
    !self.blank?
  end
end

Object.send :include, ObjectExtension
