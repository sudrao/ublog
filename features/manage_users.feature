Feature: Manage users
  In order to use ublog
  I
  want to have a home page
  
  Scenario: Register new user or log in
    Given I am not logged in
    And I go to the root page

    Then I should be redirected to the login page
    When I enter my credentials
    Then I should be on my home page
