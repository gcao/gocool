Given /^I have uploaded a few games$/ do
  Upload.create!(:upload => File.new(RAILS_ROOT + "/spec/fixtures/sgf/good.sgf"))
  Upload.create!(:upload => File.new(RAILS_ROOT + "/spec/fixtures/sgf/good1.sgf"))
end

Then /I should see recently uploaded games/ do
  response.should contain(I18n.translate('homepage.recently_uploads'))
  response.should contain('White (W) vs. Black (B)')
end
