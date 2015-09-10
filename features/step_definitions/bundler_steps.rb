Given(/^a Gemfile\.lock where "([^"]*)" is set to version "([^"]*)"$/) do |gem, version|
  step(
    'a file named "Gemfile.lock" with:',
    <<-EOS.strip_heredoc
    GEM
      remote: https://rubygems.org/
      specs:
        #{gem} (#{version})
        minitest (5.8.0)
        rake (10.4.2)

    PLATFORMS
      ruby

    DEPENDENCIES
      #{gem}
      minitest
      rake

    BUNDLED WITH
       1.10.6
    EOS
  )
end
