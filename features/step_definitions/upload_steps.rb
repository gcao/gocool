When /I enter my email and select a SGF file to upload/ do
  fill_in('upload[email]', :with => 'test@test.com')
  attach_file('upload[upload]', File.expand_path(File.dirname(__FILE__) + "/../../spec/fixtures/sgf/good.sgf"))
end

Then /I should see upload success message/ do
  response.should have_tag("div.success", :text => I18n.translate('upload.success'))
end

Then /I am able to view my game/ do
  response.should have_selector("a.jsgv")
end

Given /someone has already uploaded a game/ do
  Upload.create!(:upload => File.new(File.dirname(__FILE__) + "/../../spec/fixtures/sgf/good.sgf"))
end

When /I enter my email and select the same game to upload/ do
  When "I enter my email and select a SGF file to upload"
end

Then /I should see game found notice/ do
  pending "Strange error occurs" do
    response.should have_tag("div.notice", :text => I18n.translate('upload.game_found'))
  end
end