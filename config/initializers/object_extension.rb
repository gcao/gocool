module ObjectExtension
  class NilOr
    def method_missing(sym, *args)

    end
  end

  def not_nil?
    !self.nil?
  end

  def nil_or
    return self unless self.nil?
    NilOr.new
  end

  def not_blank?
    !self.blank?
  end

  # see https://github.com/mongoid/moped/issues/55
  def __bson_dump__(io = "", key = nil)
    as_document.__bson_dump__(io, key)
  end
end

Object.send :include, ObjectExtension
