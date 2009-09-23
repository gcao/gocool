# workaround for running features from TextMate
require File.expand_path(File.dirname(__FILE__) + '/../support/env.rb')

Dir[File.expand_path(File.dirname(__FILE__) + '/../support/*.rb')].each do |file|
  require file
end

Dir[File.expand_path(File.dirname(__FILE__) + '/../step_definitions/*.rb')].each do |file|
  require file
end