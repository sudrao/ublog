Feature: Manage blogs
  In order to communicate
  I as a user
  want to post blogs and view others' blogs

  Scenario: Post a blog on home page
    Given I am logged in
    And I am on my home page
    And I post a blog
    Then I should see my blog appear

  Scenario: Post a blog on another user's page
    Given I am logged in
    And I visit another user's page
    And I post a blog
    Then I should see my blog appear
    When I visit my home page
    Then I should see my blog


