require 'spec_helper'

describe Minitel::Client, '#initialize' do
  before do
    url = "https://u:p@foo.com"
    client = Minitel::Client.new(url)
    @data = client.connection.data
  end

  it 'uses the given url and credentials' do
    expect(@data[:host]).to     eq('foo.com')
    expect(@data[:user]).to     eq('u')
    expect(@data[:password]).to eq('p')
  end

  it 'includes the minitel and excon versions in the user agent' do
    user_agent = @data[:headers]['User-Agent']
    expect(user_agent).to match('minitel')
    expect(user_agent).to match(Minitel::VERSION)
    expect(user_agent).to match('excon')
    expect(user_agent).to match(Excon::VERSION)
  end

  it 'requires an https url' do
    expect{ Minitel::Client.new('http://user:pass@what.com')  }.to     raise_error(ArgumentError)
    expect{ Minitel::Client.new('https://user:pass@what.com') }.to_not raise_error
  end
end

describe Minitel::Client, '#notify_app' do
  describe 'arguments' do
    let(:defaults) { {title: 'a title', body: 'a body', app_uuid: SecureRandom.uuid} }
    let(:client)   { Minitel::Client.new('https://u:p@h.com') }

    before do
      Excon.stub({}, body: MultiJson.dump({}), status: 201)
    end

    it 'works when all 3 are present' do
      expect { client.notify_app(defaults) }.to_not raise_error
    end

    [:title, :body, :app_uuid].each do |key|
      it "fails when #{key} is missing from the arg hash" do
        defaults.delete(key)
        expect { client.notify_app(defaults) }.to raise_error(ArgumentError)
      end

      it "fails when #{key} is nil" do
        defaults[key] = nil
        expect { client.notify_app(defaults) }.to raise_error(ArgumentError)
      end
    end

    it 'fails if app_uuid is not a uuid' do
      defaults[:app_uuid] = "not a uuid"
      expect { client.notify_app(defaults) }.to raise_error(ArgumentError)
    end

    it 'fails if there is an extra key' do
      defaults.merge!( {foo: 3} )
      expect { client.notify_app(defaults) }.to raise_error(ArgumentError)
    end
  end

  describe 'action' do
    let(:defaults) { {title: 'a title', body: 'a body', app_uuid: SecureRandom.uuid} }
    let(:client)   { Minitel::Client.new('https://u:p@h.com') }

    before do
      request = {path: '/producer/messages', method: :post}
      response = {status: 201, body: MultiJson.dump({'success' => true})}
      body = MultiJson.dump({
        title: 'a title',
        body: 'a body',
        target: {type: 'app', id: defaults[:app_uuid]}
      })

      Excon.stub(request.merge(body: body), response)
    end

    it 'posts a proper json body to the producer messages endpoint' do
      expect{ client.notify_app(defaults) }.to_not raise_error

      unstubbed_body = defaults.merge({title: 'bad title'})
      expect{ client.notify_app(unstubbed_body) }.to raise_error(Excon::Errors::StubNotFound)
    end

    it 'returns a parsed json response' do
      result = client.notify_app(defaults)
      expect(result['success']).to eq(true)
    end
  end
end
