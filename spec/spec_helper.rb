$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'latest_stable'
require 'aruba/rspec'

Dir.glob(::File.expand_path('../support/*.rb', __FILE__)).each { |f| require_relative f }
