require File.dirname(__FILE__) + '/translate'
require 'yaml'

def translations
  default = YAML.load_file(File.dirname(__FILE__) + '/../translations/en_us.yml')
  translated = YAML.load_file(File.dirname(__FILE__) + '/../translations/zh_cn.yml')
  default.merge(translated)
end