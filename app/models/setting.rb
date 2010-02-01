class Setting < ActiveRecord::Base
  all.each do |setting|
    self.class.send :define_method, setting.name do |*args|
      setting = Setting.find_by_name(setting.name)
      if setting.data_type == 'Integer'
        setting.value.to_i
      elsif setting.data_type == 'Boolean'
        setting.value == 'true'
      else
        setting.value
      end
    end
  end

  def self.update name, value
    Setting.find_by_name(name.to_s).update_attribute(:value, value.to_s)
  end
end
