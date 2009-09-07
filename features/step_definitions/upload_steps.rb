When /I enter my email and select a SGF file to upload/ do
  fill_in('upload[email]', :with => 'test@test.com')
  attach_file('upload[upload]', File.expand_path(File.dirname(__FILE__) + "/../../spec/fixtures/sgf/good.sgf"))
end

Then /I should see upload success message/ do
  response.should contain(I18n.translate('upload.success'))
end

Then /I am able to view my game/ do
  response.should have_selector("a.jsgv")
end
