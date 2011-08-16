Feature: make friends
  In order to follow and receive other's blogs
  I
  want to follow others, and see and reply to their blogs

  Background:
    Given I am logged in
    Given I am on my home page
  
  Scenario: follow someone
    Given I go to another user's page
    When I follow that user
      And I go to my home page
    Then I should see a following count of 1
    When I check who all I am following
    Then I should see that user's name

