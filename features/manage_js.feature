  @javascript @CI
Feature: Check javascript specific features

  Background:
    Given I am logged in

  Scenario: reply to someone
    Given I have subscribed to another user
      And I am on my home page
    Then I should see another user's blog
    When I click the reply link
    Then I should see a reply dialog box
    When I type in a reply and submit it
    Then I should see my reply message
