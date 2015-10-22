Given(/^a Rakefile with a passing default task$/) do
  step('a file named "Rakefile" with:',
    <<-EOS.strip_heredoc
    require 'rake/testtask'

    Rake::TestTask.new do |t|
      t.pattern = '*_test.rb'
    end

    task default: :test
    EOS
  )
end

Given(/^a bundle where all gems are up to date$/) do
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'https://rubygems.org'
    gem 'papla'
    gem 'minitest', '5.8.0'
    gem 'rake'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: https://rubygems.org/
      specs:
        i18n (0.7.0)
        minitest (5.8.0)
        papla (0.1.2)
          i18n
        rake (10.4.2)

    PLATFORMS
      ruby

    DEPENDENCIES
      i18n
      minitest (= 5.8.0)
      papla
      rake

    BUNDLED WITH
       1.10.6
    EOS
  )
end

Given(/^a bundle where a gem is out of date$/) do
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'https://rubygems.org'
    gem 'papla'
    gem 'minitest'
    gem 'rake'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: https://rubygems.org/
      specs:
        i18n (0.7.0)
        minitest (5.8.0)
        papla (0.1.1)
          i18n
        rake (10.4.2)

    PLATFORMS
      ruby

    DEPENDENCIES
      i18n
      minitest
      papla
      rake

    BUNDLED WITH
       1.10.6
    EOS
  )
end

Given(/^a test that will fail for the new version of the gem$/) do
  step('a Rakefile with a passing default task')
  step(
    'a file named "gem_version_of_papla_test.rb" with:',
    <<-EOS.strip_heredoc
    require 'minitest/autorun'
    require 'papla/version'

    class TestGemVersionOfPapla < Minitest::Test
      def test_that_version_equals_expectation
        assert_equal Papla::VERSION, '0.1.1'
      end
    end
    EOS
  )
end

Then(/^I should see that I'm already on latest stable$/) do
  step('the output should contain "Already on latest stable"')
end

Then(/^then I should see which gems have been updated$/) do
  step(
    'the output should contain:',
    <<-EOS.strip_heredoc
    Updated 'papla' from 0.1.1 to 0.1.2
    success
    EOS
  )
end

Then(/^all gems in the bundle should be up to date$/) do
  step('the file "Gemfile.lock" should contain "papla (0.1.2)"')
end

Then(/^I should see that the test failed$/) do
  step(
    'the output should contain:',
    <<-EOS.strip_heredoc
    Updated 'papla' from 0.1.1 to 0.1.2
    Tests failed
    EOS
  )
end

Then(/^the bundle should not have changed$/) do
  step('the file "Gemfile.lock" should contain "papla (0.1.1)"')
end

Given(/^a bundle where a gem is out of date and its newer version removes a dependency$/) do
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'https://rubygems.org'
    gem 'capistrano'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: https://rubygems.org/
      specs:
        capistrano (2.15.6)
          highline
          net-scp (>= 1.0.0)
          net-sftp (>= 2.0.0)
          net-ssh (>= 2.0.14)
          net-ssh-gateway (>= 1.1.0)
        highline (1.7.8)
        net-scp (1.2.1)
          net-ssh (>= 2.6.5)
        net-sftp (2.1.2)
          net-ssh (>= 2.6.5)
        net-ssh (3.0.1)
        net-ssh-gateway (1.2.0)
          net-ssh (>= 2.6.5)

    PLATFORMS
      ruby

    DEPENDENCIES
      capistrano

    BUNDLED WITH
       1.10.6
    EOS
  )
end

Then(/^I should see that the dependency has been removed$/) do
  step('the output should contain:', "Removed 'highline'")
end
