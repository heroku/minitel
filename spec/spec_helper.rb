require 'rubygems'
require 'rspec'
require 'minitel'

RSpec.configure do |config|
  config.before(:all) do
    Excon.defaults[:mock] = true
  end

  config.after(:each) do
    Excon.stubs.clear
  end
end
