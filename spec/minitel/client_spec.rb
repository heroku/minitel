require 'spec_helper'

describe Minitel::Client, '#initialize' do
  it 'requires an https url' do
    expect{ Minitel::Client.new('http://user:pass@what.com')  }.to     raise_error
    expect{ Minitel::Client.new('https://user:pass@what.com') }.to_not raise_error
  end
end
