Feature: Update gem to latest version

  As a developer using bundler and minitest
  I want to be able to run a single command to update all gems to newer
  versions where the update doesn't fail the tests

  Background:
    Given a file named "Gemfile" with:
      """
      source 'https://rubygems.org'
      gem 'papla'
      """
  Scenario: Gem is already up to date
    Given a Gemfile.lock where "papla" is set to version "0.1.2"
    When I run `latest_stable`
    Then the output should contain "Already on latest stable"

  Scenario: Gem needs minor version update and tests pass with new version
    Given a Gemfile.lock where "papla" is set to version "0.1.1"
    When I run `latest_stable`
    Then the output should contain:
      """
      Updated 'papla' from 0.1.1 to 0.1.2
      Added 'i18n' 0.7.0
      success
      """
    And the file "Gemfile.lock" should contain "papla (0.1.2)"
    And the file "Gemfile.lock" should contain "i18n (0.7.0)"
