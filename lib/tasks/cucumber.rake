$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')

begin
  require 'cucumber/rake/task'
  
  Cucumber::Rake::Task.new(:features) do |t|
    t.fork = true
    t.cucumber_opts = "-r features/support/env.rb -r features/support/plain.rb -r features/step_definitions"
    t.feature_pattern = "features/plain/*.feature"
  end

  Cucumber::Rake::Task.new(:'features:selenium') do |t|
    t.fork = true
    t.cucumber_opts = "-r features/support/env.rb -r features/support/enhanced.rb -r features/step_definitions"
    t.feature_pattern = "features/enhanced/*.feature features/plain/*.feature"
  end
  
  task :features => 'db:test:prepare'
  task :'features:selenium' => 'db:test:prepare'
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end
