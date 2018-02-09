# 𝕄𝕀ℕ𝕀𝕋𝔼𝕃
A 𝕋𝔼𝕃𝔼𝕏 client

[![Gem Version](https://badge.fury.io/rb/minitel.svg)](http://badge.fury.io/rb/minitel)
[![Build Status](https://travis-ci.org/heroku/minitel.svg?branch=master)](https://travis-ci.org/heroku/minitel)

## Producer Credentials

Get credentials to use by following the instructions here: https://github.com/heroku/engineering-docs/blob/master/components/telex/user-guide.md

## Installing Minitel
You'll need to add our private gemserver first, see here: <https://gemgate-heroku-internal-gems.herokuapp.com/setup-instructions>

## Quick Setup
This will help you send a notification to just yourself, as a sanity check that everything is set up properly

Before you do this:
- Get your producer credentials (above)
- get minitel installed locally (above)
- Grab your user account id, for example by doing: `heroku api get /account | jq '.id' -r`

```
# minitel-testing.rb
require 'minitel'
TELEX_URL = 'https://user:pass@telex.heroku.com'
MY_USER_ID = '123'

client = Minitel::Client.new(TELEX_URL)

message = client.notify_user(user_uuid: MY_USER_ID, title: 'Test Notification', body: 'Test Notification Body.')
puts "message " + message["id"] + " sent"
```

Once you run this, you should receive both:
- receive an email (eventually, depending on the backlog)
- see this in Dashboard's Notification Center

## Usage Examples

``` ruby
require 'minitel'
# create a client
client = Minitel::Client.new("https://user:pass@telex.heroku.com")

# send a notification to the owner and collaborators of an app
client.notify_app(app_uuid: '...', title: 'Your database is on fire!', body: 'Sorry.')
# => {"id"=>"uuid of message"}

# send a notification to a user
client.notify_user(user_uuid: '...', title: 'Here is your invoice', body: 'You owe us 65k.')
# => {"id"=>"uuid of message"}

# send a notification with an email action
# see: https://developers.google.com/gmail/markup/reference/go-to-action
client.notify_user(user_uuid: '...',
  title: 'Here is your invoice',
  body: 'You owe us 65k.',
  action: { label: 'View Invoice', url: 'https://heroku.com/invoices/12345-12-98765'})

# add follow-up to a previous notification
client.add_followup(message_uuid: '...', body: 'here are even more details')
```
