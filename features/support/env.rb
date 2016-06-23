require 'bundler'
require 'aruba/cucumber'
require 'open-uri'

tmp_dir = '/tmp/gemserver'
gemserver_pid = Bundler.with_clean_env { spawn("gem server --dir=#{tmp_dir}") }

begin
  tries ||= 10
  open('http://localhost:8808/').read
rescue
  sleep 1
  retry unless (tries -= 1).zero?
end

Aruba.configure do |config|
  config.command_search_paths << 'exe'
end

Before do
  FileUtils.rm_rf(tmp_dir)

  Bundler.with_clean_env do
    `gem uninstall ls_example_gem ls_first_gem ls_second_gem ls_dependencies_gem --force`
  end
end

# After all
at_exit do
  Process.kill('TERM', gemserver_pid)
  FileUtils.rm_rf(tmp_dir)

  Bundler.with_clean_env do
    `gem uninstall ls_example_gem ls_first_gem ls_second_gem ls_dependencies_gem --force`
  end
end
