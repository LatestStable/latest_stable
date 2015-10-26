Feature: Update gem to latest version

  As a developer using bundler and minitest
  I want to be able to run a single command to update all gems to newer
  versions where the update doesn't fail the tests

  Scenario: Gem is already up to date
    Given a bundle where all gems are up to date
    When I run latest_stable
    Then I should see that I'm already on latest stable

  Scenario: Gem needs minor version update and tests pass with new version
    Given a bundle where a gem is out of date
    And a Rakefile with a passing default task
    When I run latest_stable
    Then then I should see which gems have been updated
    And all gems in the bundle should be up to date

  Scenario: Gem needs minor version update and tests fail with new version
    Given a bundle where a gem is out of date
    And a test that will fail for the new version of the gem
    When I run latest_stable
    Then I should see that the test failed
    And the bundle should not have changed

  Scenario: Gem dependencies changed after update
    Given a bundle where a gem is out of date and its newer version modifies its dependencies
    When I run latest_stable
    Then I should see that a dependency has been removed
    And I should see that a dependency has been added
