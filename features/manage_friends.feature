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

  @javascript
  Scenario: reply to someone
    Given I have subscribed to another user
      And I see another user's blog
    When I click the reply link
    Then I should see a reply dialog box
    When I type in a reply and submit it
    Then I should see my reply message
