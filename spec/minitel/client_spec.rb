require 'spec_helper'

describe Minitel::Client, '#initialize' do
  it 'requires an https url' do
    expect{ Minitel::Client.new('http://user:pass@what.com')  }.to     raise_error(ArgumentError)
    expect{ Minitel::Client.new('https://user:pass@what.com') }.to_not raise_error
  end

  it 'uses the given url and credentials' do
    url = "https://u:p@foo.com"
    mock = double(:excon)
    expect(Excon).to receive(:new).with(url).and_return(mock)

    client = Minitel::Client.new(url)

    expect(client.connection).to eq(mock)
  end
end

describe Minitel::Client, '#notify_app' do
  describe 'arguments' do
    let(:defaults) { {title: 'a title', body: 'a body', app_uuid: SecureRandom.uuid} }
    let(:client) { Minitel::Client.new('https://u:p@h.com') }

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
    let(:request) { {path: '/producer/messages', method: :post} }
    let(:client)  { Minitel::Client.new('https://u:p@h.com') }

    it 'posts a proper json body to the producer messages endpoint' do
      response = {status: 201, body: MultiJson.dump({'success' => true})}
      body = MultiJson.dump({
        title: 'a title',
        body: 'a body',
        target: {type: 'app', id: defaults[:app_uuid]}
      })

      Excon.stub(request.merge(body: body), response)
      expect{ client.notify_app(defaults) }.to_not raise_error

      unstubbed_body = defaults.merge({title: 'bad title'})
      expect{ client.notify_app(unstubbed_body) }.to raise_error(Excon::Errors::StubNotFound)
    end

    it 'returns a parsed json response' do

    end
  end
end
