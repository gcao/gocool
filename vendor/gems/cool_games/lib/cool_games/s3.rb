module CoolGames
  module S3    
    def self.wrap_bucket_name bucket_name
      case Rails.env
      when 'production' then bucket_name
      when 'development' then "#{bucket_name}_dev"
      else "#{bucket_name}_test"
      end
    end
  end
end
