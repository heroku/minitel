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
  describe 'action' do
    let(:defaults) { {title: 'a title', body: 'a body', app_uuid: SecureRandom.uuid} }
    let(:client)   { Minitel::Client.new('https://telex.com') }

    before do
      @stub = stub_request(:post, 'https://telex.com/producer/messages').
        to_return(status: 201, body: MultiJson.encode(success: true))
    end

    it 'posts a proper json body to the producer messages endpoint' do
      client.notify_app(defaults)
      body = MultiJson.encode(
        title: 'a title',
        body: 'a body',
        target: {type: 'app', id: defaults[:app_uuid]})
      expect(@stub.with(body: body)).to have_been_requested
    end

    it 'returns a parsed json response' do
      result = client.notify_app(defaults)
      expect(result['success']).to eq(true)
    end
  end
end


describe Minitel::Client, '#notify_user' do
  let(:defaults) { {title: 'a title', body: 'a body', user_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://telex.com') }

  before do
    @stub = stub_request(:post, 'https://telex.com/producer/messages').
      to_return(status: 201, body: MultiJson.encode(success: true))
  end

  it 'posts a proper json body to the producer messages endpoint' do
    client.notify_user(defaults)
    body = MultiJson.encode(
      title: 'a title',
      body: 'a body',
      target: {type: 'user', id: defaults[:user_uuid]})
    expect(@stub.with(body: body)).to have_been_requested
  end

  it 'returns a parsed json response' do
    result = client.notify_user(defaults)
    expect(result['success']).to eq(true)
  end
end

describe Minitel::Client, '#add_followup' do
  let(:defaults) { {body: 'a body', message_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://telex.com') }

  before do
    @stub = stub_request(:post, "https://telex.com/producer/messages/#{defaults[:message_uuid]}/followups").
      to_return(status: 201, body: MultiJson.encode(success: true))
  end

  it 'posts a proper json body to the producer messages endpoint' do
    client.add_followup(defaults)
    body = MultiJson.encode(body: 'a body')
    expect(@stub.with(body: body)).to have_been_requested
  end

  it 'returns a parsed json response' do
    result = client.add_followup(defaults)
    expect(result['success']).to eq(true)
  end
end
