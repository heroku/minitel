require 'multi_json'
require 'excon'

module Minitel
  class Client
    attr_accessor :telex_url

    def initialize(telex_url)
      raise "Bad Url" unless telex_url.start_with? "https://"
      self.telex_url = telex_url
    end

    def notify_app(args)
      strict_args(args.keys, [:app_uuid, :body, :title])

      title    = args.fetch(:title)
      body     = args.fetch(:body)
      app_uuid = args.fetch(:app_uuid)

      message = {
        title: title,
        body: body,
        target: {type: 'app', id: app_uuid}
      }

      response = Excon.post("#{telex_url}/producer/messages",
                   body: MultiJson.dump(message),
                   expects: 201)

      MultiJson.load(response.body)
    end

    private
    # A Ruby 2.1 required keyword argument sorta backport
    def strict_args(keys, accept_keys)
      if keys.sort != accept_keys.sort
        delta = accept_keys - keys
        raise ArgumentError, "missing or extra keywords: #{delta.join(', ')}"
      end
    end
  end
end
