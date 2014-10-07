require 'spec_helper'

describe Minitel::Client, '#initialize' do
  it 'requires an https url' do
    expect{ Minitel::Client.new('http://user:pass@what.com')  }.to     raise_error
    expect{ Minitel::Client.new('https://user:pass@what.com') }.to_not raise_error
  end
end

describe Minitel::Client, '#notify_app' do
  describe 'arguments' do
    let(:default) { {title: 'a title', body: 'a body', app_uuid: SecureRandom.uuid} }
    let(:client) { Minitel::Client.new('https://u:p@h.com') }

    it 'works when all 3 are present' do
      expect { client.notify_app(default) }.to_not raise_error
    end

    [:title, :body, :app_uuid].each do |key|
      it "fails when #{key} is missing from the arg hash" do
        default.delete(key)
        expect { client.notify_app(default) }.to raise_error(ArgumentError)
      end

      it "fails when #{key} is nil" do
        default[key] = nil
        expect { client.notify_app(default) }.to raise_error(ArgumentError)
      end
    end

    it 'fails if app_uuid is not a uuid' do
      default[:app_uuid] = "not a uuid"
      expect { client.notify_app(default) }.to raise_error(ArgumentError)
    end

    it 'fails if there is an extra key' do
      default.merge!( {foo: 3} )
      expect { client.notify_app(default) }.to raise_error(ArgumentError)
    end
  end
end
