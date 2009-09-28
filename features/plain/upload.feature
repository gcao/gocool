Feature: As an Internet user, I want to upload my SGF files to gocool

Scenario: Upload one file
  When I am on Upload Games page
  And I enter my email and select a SGF file to upload
  And I click "Upload"
  Then I should see upload success message
  And I am able to view my game
  
Scenario: Upload game which is already in database
  Given someone has already uploaded a game
  When I am on Upload Games page
  And I enter my email and select the same game to upload
  And I click "Upload"
  Then I should see game found notice
  And I am able to view my game