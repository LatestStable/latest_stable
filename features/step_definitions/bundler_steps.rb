Given(/^a gemserver with (.*) installed$/) do |gem_file|
  gem_file_path = "spec/fixtures/gems/#{gem_file}"

  Bundler.with_clean_env do
    `gem install #{gem_file_path} --install-dir /tmp/gemserver/ --source http://localhost:8808`
  end
end

Given(/^a Rakefile with a passing default task$/) do
  step(
    'a file named "Rakefile" with:',
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
  step('a gemserver with ls_example_gem-0.1.0.gem installed')
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'http://localhost:8808'
    gem 'ls_example_gem'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: http://localhost:8808/
      specs:
        ls_example_gem (0.1.0)

    PLATFORMS
      ruby

    DEPENDENCIES
      ls_example_gem
    EOS
  )
end

Given(/^a bundle where a gem is out of date$/) do
  step('a gemserver with ls_example_gem-0.1.0.gem installed')
  step('a gemserver with ls_example_gem-0.2.0.gem installed')
  step('a gemserver with minitest-5.9.0.gem installed')
  step('a gemserver with rake-11.2.2.gem installed')
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'http://localhost:8808'
    gem 'ls_example_gem'
    gem 'minitest'
    gem 'rake'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: https://localhost:8808/
      specs:
        ls_example_gem (0.1.0)
        minitest (5.9.0)
        rake (11.2.2)

    PLATFORMS
      ruby

    DEPENDENCIES
      ls_example_gem
    EOS
  )
end

Given(/^a bundle where two gems are out of date$/) do
  step('a gemserver with ls_first_gem-0.1.0.gem installed')
  step('a gemserver with ls_first_gem-0.2.0.gem installed')
  step('a gemserver with ls_second_gem-0.1.0.gem installed')
  step('a gemserver with ls_second_gem-0.2.0.gem installed')
  step('a gemserver with minitest-5.9.0.gem installed')
  step('a gemserver with rake-11.2.2.gem installed')
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'http://localhost:8808'
    gem 'ls_first_gem'
    gem 'ls_second_gem'
    gem 'minitest'
    gem 'rake'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: http://localhost:8808/
      specs:
        ls_first_gem (0.1.0)
        ls_second_gem (0.1.0)
        minitest (5.9.0)
        rake (11.2.2)

    PLATFORMS
      ruby

    DEPENDENCIES
      ls_first_gem
      ls_second_gem
      minitest
      rake
    EOS
  )
end

Given(/^a test that will fail for the new version of the gem$/) do
  step('a Rakefile with a passing default task')
  step(
    'a file named "gem_version_of_ls_second_gem_test.rb" with:',
    <<-EOS.strip_heredoc
    require 'minitest/autorun'
    require 'ls_second_gem'

    class TestGemVersionOfLsSecondGem < Minitest::Test
      def test_that_version_equals_expectation
        assert_equal '0.1.0', LsSecondGem::VERSION
      end
    end
    EOS
  )
end

Given(/^one of the gems will cause the tests to fail if updated$/) do
  step('a test that will fail for the new version of the gem')
end

Then(/^the good gem should be updated$/) do
  step('the file "Gemfile.lock" should contain "ls_first_gem (0.2.0)"')
end

Then(/^the bad gem should stay outdated$/) do
  step('the file "Gemfile.lock" should contain "ls_second_gem (0.1.0)"')
end

Then(/^I should see that I'm already on latest stable$/) do
  step('the output should contain "Already on latest stable"')
end

Then(/^I should see that the good gem has been updated$/) do
  step(
    'the output should contain:',
    <<-EOS.strip_heredoc
    Updating 'ls_first_gem' from 0.1.0 to 0.2.0 : success
    EOS
  )
end

Then(/^I should see that the test failed for the bad gem$/) do
  step(
    'the output should contain:',
    <<-EOS.strip_heredoc
    Updating 'ls_second_gem' from 0.1.0 to 0.2.0 : Tests failed
    EOS
  )
end

Then(/^then I should see which gems have been updated$/) do
  step(
    'the output should contain:',
    <<-EOS.strip_heredoc
    Updated 'ls_example_gem' from 0.1.0 to 0.2.0
    success
    EOS
  )
end

Then(/^all gems in the bundle should be up to date$/) do
  step('the file "Gemfile.lock" should contain "ls_example_gem (0.2.0)"')
end

Then(/^I should see that the test failed$/) do
  step(
    'the output should contain:',
    <<-EOS.strip_heredoc
    Updated 'ls_example_gem' from 0.1.0 to 0.2.0
    Tests failed
    EOS
  )
end

Then(/^the bundle should not have changed$/) do
  step('the file "Gemfile.lock" should contain "ls_example_gem (0.1.0)"')
end

Given(/^a bundle where a gem is out of date and its newer version modifies its dependencies$/) do
  step('a gemserver with ls_example_gem-0.1.0.gem installed')
  step('a gemserver with ls_example_gem-0.2.0.gem installed')
  step('a gemserver with ls_first_gem-0.1.0.gem installed')
  step('a gemserver with ls_first_gem-0.2.0.gem installed')
  step('a gemserver with ls_second_gem-0.1.0.gem installed')
  step('a gemserver with ls_second_gem-0.2.0.gem installed')
  step('a gemserver with ls_dependencies_gem-0.1.0.gem installed')
  step('a gemserver with ls_dependencies_gem-0.2.0.gem installed')
  step('a gemserver with minitest-5.9.0.gem installed')
  step('a gemserver with rake-11.2.2.gem installed')
  step(
    'a file named "Gemfile" with:',
    <<-EOS.strip_heredoc
    source 'http://localhost:8808'
    gem 'ls_dependencies_gem'
    gem 'minitest'
    gem 'rake'
    EOS
  )
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: http://localhost:8808/
      specs:
        ls_dependencies_gem (0.1.0)
          ls_example_gem (~> 0)
          ls_first_gem (~> 0)
        ls_example_gem (0.1.0)
        ls_first_gem (0.1.0)
        minitest (5.9.0)
        rake (11.2.2)

    PLATFORMS
      ruby

    DEPENDENCIES
      ls_dependencies_gem
      minitest
      rake
    EOS
  )
end

Then(/^I should see that a dependency has been removed$/) do
  step('the output should contain:', "Removed 'ls_first_gem'")
end

Then(/^I should see that a dependency has been added$/) do
  step('the output should contain:', "Added 'ls_second_gem'")
end

When(/^I run latest_stable$/) do
  step('I run `latest_stable`')
end
