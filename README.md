# 𝕄𝕀ℕ𝕀𝕋𝔼𝕃

A 𝕋𝔼𝕃𝔼𝕏 client

[![Gem Version](https://badge.fury.io/rb/minitel.svg)](http://badge.fury.io/rb/minitel)
[![Build Status](https://github.com/heroku/minitel/actions/workflows/ruby.yml/badge.svg)](https://github.com/heroku/minitel/actions/workflows/ruby.yml)

## Producer Credentials

Get credentials to use by following the instructions here: <https://github.com/heroku/telex/blob/main/docs/user_guide.md>

## Quick Setup

This will help you send a notification to just yourself, as a sanity check that everything is set up properly

Before you do this:

- Get your producer credentials (above)
- get `minitel` (above) and `dotenv` installed locally
- Grab your user account id, for example by doing: `heroku api get /account | jq '.id' -r`

```shell
# .env
TELEX_URL = 'https://user:pass@telex.heroku.com'
MY_USER_ID = '123'
```

```ruby
# minitel-testing.rb or irb
require 'dotenv/load'
require 'minitel'

client = Minitel::Client.new(ENV['TELEX_URL'])

message = client.notify_user(user_uuid: ENV['MY_USER_ID'], title: 'Test Notification', body: 'Test Notification Body.')
puts "message " + message['id'] + " sent"
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

## Releasing

1. **Bump the version** in `lib/minitel/version.rb`

2. **Update `CHANGELOG.md`** — move entries from `[Unreleased]` into a new versioned section and update the comparison links at the bottom

3. **Commit the changes**

   ```shell
   git add lib/minitel/version.rb CHANGELOG.md
   git commit -m "version -> x.y.z"
   ```

4. **Create and push a git tag**

   ```shell
   git tag vx.y.z
   git push origin main --tags
   ```

5. **Build and push the gem to RubyGems.org**

   ```shell
   gem build
   gem push minitel-x.y.z.gem
   ```
