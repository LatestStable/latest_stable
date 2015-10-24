# LatestStable

LatestStable makes it dead simple to stay up to date with the upstream changes of your gem dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'latest_stable'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install latest_stable

## Usage

When you run latest_stable from the terminal in a git directory.

    $ latest_stable

It will do the following things for you:

* checks out master and runs your test suite to ensure that tests
  are passing initially
* checks out a new branch 'update_gems_to_latest_stable'
* gets the list of outdated gems and for each of those
  * updates the gem
  * reruns your test suite
  * commits updated gem if tests pass or reverts update if they fail

Afterwards you'll have a branch with all gems that could cleanly be updated.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec latest_stable` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LatestStable/latest_stable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

