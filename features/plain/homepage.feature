Feature: Home Page

Scenario: Recent games
  Given I have uploaded a few games
  When I am on the homepage
  Then I should see recently uploaded games