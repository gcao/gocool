unless ENV['CUCUMBER_PROFILE'] == 'selenium'
  Webrat.configure do |config|
    config.mode = :rails
  end

  # truncate your tables here if you are using the same database as selenium, since selenium doesn't use transactional fixtures
  Cucumber::Rails.use_transactional_fixtures
end