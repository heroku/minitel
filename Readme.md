# 𝕄𝕀ℕ𝕀𝕋𝔼𝕃
A 𝕋𝔼𝕃𝔼𝕏 client

[![Gem Version](https://badge.fury.io/rb/minitel.svg)](http://badge.fury.io/rb/minitel)
[![Build Status](https://travis-ci.org/heroku/minitel.svg?branch=master)](https://travis-ci.org/heroku/minitel)

## Usage

``` ruby
require 'minitel'
# create a client
client = Minitel::Client.new("https://user:pass@telex.heroku.com")

# send a notifcation to the owner and collaborators of an app
client.notify_app(app_uuid: '...', title: 'Something happened', body: 'here are the details')
# => {"id"=>"uuid of message"}

# send a notifcation to a user
client.notify_user(user_uuid: '...', title: 'Something happened', body: 'here are the details')
# => {"id"=>"uuid of message"}

# add folloup to a previous notificaiton
client.notify_user(message_uuid: '...', body: 'here are even more details')
```
