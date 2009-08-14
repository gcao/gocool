Feature: As an Internet user, I want to upload my SGF files to gocool

Scenario: Upload one file
  Given I am on Upload Games page
  When I enter my email and select a SGF file to upload
  And I click "Upload"
  Then I should see upload success message
  And I am able to view my game