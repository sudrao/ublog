Feature: Manage users
  In order to use ublog
  I
  want to have a home page
  
  Scenario: Register new user or log in
    Given I am not logged in
    And I visit the root page

    Then I should see the login page
    When I enter my credentials
    Then I should see my home page
