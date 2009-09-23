$LOAD_PATH.unshift(RAILS_ROOT + '/vendor/plugins/cucumber/lib') if File.directory?(RAILS_ROOT + '/vendor/plugins/cucumber/lib')

namespace :cucumber do
  task :plain do
    ENV['CUCUMBER_PROFILE'] = 'plain'
  end
  
  task :selenium do
    ENV['CUCUMBER_PROFILE'] = 'selenium'
  end
end

begin
  require 'cucumber/rake/task'
  
  Cucumber::Rake::Task.new(:features) do |t|
    t.fork = true
    t.cucumber_opts = "-r features/support -r features/step_definitions"
    t.feature_pattern = "features/plain/*.feature"
  end

  Cucumber::Rake::Task.new(:'features:selenium') do |t|
    t.fork = true
    t.cucumber_opts = "-r features/support -r features/step_definitions"
    t.feature_pattern = "features/enhanced/*.feature features/plain/*.feature"
  end
  
  task :features => ['db:cucumber:reset', 'cucumber:plain']
  task :'features:selenium' => ['db:cucumber:reset', 'cucumber:selenium']
rescue LoadError
  desc 'Cucumber rake task not available'
  task :features do
    abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
  end
end

namespace :db do
  namespace :cucumber do
    task :reset do
      RAILS_ENV = 'cucumber'
      Rake::Task[:'db:migrate:reset'].invoke
    end
  end
end