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


describe Minitel::Client, '#notify_user' do
  let(:defaults) { {title: 'a title', body: 'a body', user_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://u:p@h.com') }

  before do
    request = {path: '/producer/messages', method: :post}
    response = {status: 201, body: MultiJson.dump({'success' => true})}
    body = MultiJson.dump({
      title: 'a title',
      body: 'a body',
      target: {type: 'user', id: defaults[:user_uuid]}
    })

    Excon.stub(request.merge(body: body), response)
  end

  it 'posts a proper json body to the producer messages endpoint' do
    expect{ client.notify_user(defaults) }.to_not raise_error

    unstubbed_body = defaults.merge({title: 'bad title'})
    expect{ client.notify_user(unstubbed_body) }.to raise_error(Excon::Errors::StubNotFound)
  end

  it 'returns a parsed json response' do
    result = client.notify_user(defaults)
    expect(result['success']).to eq(true)
  end
end

describe Minitel::Client, '#add_followup' do
  let(:defaults) { {body: 'a body', message_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://u:p@h.com') }

  before do
    request = {path: "/producer/messages/#{defaults[:message_uuid]}/followups", method: :post}
    response = {status: 201, body: MultiJson.dump({'success' => true})}
    body = MultiJson.dump({
      body: 'a body',
    })

    Excon.stub(request.merge(body: body), response)
  end

  it 'posts a proper json body to the producer messages endpoint' do
    expect{ client.add_followup(defaults) }.to_not raise_error

    unstubbed_body = defaults.merge({message_uuid: SecureRandom.uuid})
    expect{ client.add_followup(unstubbed_body) }.to raise_error(Excon::Errors::StubNotFound)
  end

  it 'returns a parsed json response' do
    result = client.add_followup(defaults)
    expect(result['success']).to eq(true)
  end
end
