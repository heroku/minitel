require 'spec_helper'

RSpec.describe Minitel::Client, '#initialize' do
  before do
    url = "https://EXAMPLE-KEY0-0000-0000-000000000000:EXAMPLE-SEC0-0000-0000-000000000000@telex.example.com"
    @client = Minitel::Client.new(url)
  end

  it 'uses the given url and credentials' do
    expect(@client.uri.host).to eq('telex.example.com')
    expect(@client.user).to     eq('EXAMPLE-KEY0-0000-0000-000000000000')
    expect(@client.password).to eq('EXAMPLE-SEC0-0000-0000-000000000000')
  end

  it 'requires an https url' do
    expect{ Minitel::Client.new('http://user:pass@what.com')  }.to     raise_error(ArgumentError)
    expect{ Minitel::Client.new('https://user:pass@what.com') }.to_not raise_error
  end
end

RSpec.describe Minitel::Client, '#notify_app' do
  let(:defaults) { {title: 'a title', body: 'a body', app_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://EXAMPLE-KEY0-0000-0000-000000000000:EXAMPLE-SEC0-0000-0000-000000000000@telex.example.com') }

  before do
    @stub = WebMock.stub_request(:post, 'https://telex.example.com/producer/messages').
      to_return(status: 201, body: JSON.generate(success: true))
  end

  it 'posts a proper json body to the producer messages endpoint' do
    client.notify_app(defaults)
    body = JSON.generate(
      title: 'a title',
      body: 'a body',
      target: {type: 'app', id: defaults[:app_uuid]})
    expect(@stub.with(body: body)).to have_been_requested
  end

  it 'sends basic auth credentials' do
    client.notify_app(defaults)
    expect(@stub.with(basic_auth: ['EXAMPLE-KEY0-0000-0000-000000000000', 'EXAMPLE-SEC0-0000-0000-000000000000'])).to have_been_requested
  end

  it 'sends correct content-type and user-agent headers' do
    client.notify_app(defaults)
    expect(@stub.with(headers: {
      'Content-Type' => 'application/json',
      'User-Agent' => "minitel/#{Minitel::VERSION}"
    })).to have_been_requested
  end

  it 'supports actions' do
    action = { label: 'omg', url: 'https://foo' }
    client.notify_app(defaults.merge(action: action))
    post_with_action = @stub.with do |req|
      body = JSON.parse(req.body, symbolize_names: true)
      body[:action] == action
    end
    expect(post_with_action).to have_been_requested
  end

  it 'returns a parsed json response' do
    result = client.notify_app(defaults)
    expect(result['success']).to eq(true)
  end
end

RSpec.describe Minitel::Client, '#notify_user' do
  let(:defaults) { {title: 'a title', body: 'a body', user_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://EXAMPLE-KEY0-0000-0000-000000000000:EXAMPLE-SEC0-0000-0000-000000000000@telex.example.com') }

  before do
    @stub = WebMock.stub_request(:post, 'https://telex.example.com/producer/messages').
      to_return(status: 201, body: JSON.generate(success: true))
  end

  it 'posts a proper json body to the producer messages endpoint' do
    client.notify_user(defaults)
    body = JSON.generate(
      title: 'a title',
      body: 'a body',
      target: {type: 'user', id: defaults[:user_uuid]})
    expect(@stub.with(body: body)).to have_been_requested
  end

  it 'sends basic auth credentials' do
    client.notify_user(defaults)
    expect(@stub.with(basic_auth: ['EXAMPLE-KEY0-0000-0000-000000000000', 'EXAMPLE-SEC0-0000-0000-000000000000'])).to have_been_requested
  end

  it 'sends correct content-type and user-agent headers' do
    client.notify_user(defaults)
    expect(@stub.with(headers: {
      'Content-Type' => 'application/json',
      'User-Agent' => "minitel/#{Minitel::VERSION}"
    })).to have_been_requested
  end

  it 'supports actions' do
    action = { label: 'omg', url: 'https://foo' }
    client.notify_user(defaults.merge(action: action))
    post_with_action = @stub.with do |req|
      body = JSON.parse(req.body, symbolize_names: true)
      body[:action] == action
    end
    expect(post_with_action).to have_been_requested
  end

  it 'returns a parsed json response' do
    result = client.notify_user(defaults)
    expect(result['success']).to eq(true)
  end
end

RSpec.describe Minitel::Client, '#add_followup' do
  let(:defaults) { {body: 'a body', message_uuid: SecureRandom.uuid} }
  let(:client)   { Minitel::Client.new('https://EXAMPLE-KEY0-0000-0000-000000000000:EXAMPLE-SEC0-0000-0000-000000000000@telex.example.com') }

  before do
    @stub = WebMock.stub_request(:post, "https://telex.example.com/producer/messages/#{defaults[:message_uuid]}/followups").
      to_return(status: 201, body: JSON.generate(success: true))
  end

  it 'posts a proper json body to the producer messages endpoint' do
    client.add_followup(defaults)
    body = JSON.generate(body: 'a body')
    expect(@stub.with(body: body)).to have_been_requested
  end

  it 'sends basic auth credentials' do
    client.add_followup(defaults)
    expect(@stub.with(basic_auth: ['EXAMPLE-KEY0-0000-0000-000000000000', 'EXAMPLE-SEC0-0000-0000-000000000000'])).to have_been_requested
  end

  it 'sends correct content-type and user-agent headers' do
    client.add_followup(defaults)
    expect(@stub.with(headers: {
      'Content-Type' => 'application/json',
      'User-Agent' => "minitel/#{Minitel::VERSION}"
    })).to have_been_requested
  end

  it 'returns a parsed json response' do
    result = client.add_followup(defaults)
    expect(result['success']).to eq(true)
  end
end
