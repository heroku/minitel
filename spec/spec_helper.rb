require 'rubygems'
require 'rspec'
require 'webmock/rspec'
require 'minitel'

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
end
