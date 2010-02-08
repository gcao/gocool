module Admin::BaseHelper
  def gaming_platform_id_column record
    record.gaming_platform.nil_or.name
  end

  def gaming_platform_id_form_column record, input_name
    select :record, :gaming_platform_id, GamingPlatform.all.map{|platform| [platform.name, platform.id]}, { :include_blank => true }
  end
end
