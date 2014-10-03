require 'json'
require 'excon'

module Minitel
  class Client
    attr_accessor :telex_url

    def initialize(telex_url)
      raise "Bad Url" unless telex_url.start_with? "https://"
      self.telex_url = telex_url
    end

    def notify_app(args)
      message = {
        title: args.fetch(:title),
        body: args.fetch(:body),
        target: {type: 'app', id: args.fetch(:app_uuid)}
      }

      response = Excon.post("#{telex_url}/producer/messages",
                   body: JSON.dump(message),
                   expects: 201)

      JSON.parse(response.body)
    end
  end
end
