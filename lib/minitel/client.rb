require 'multi_json'
require 'excon'

module Minitel
  class Client
    attr_accessor :connection

    def initialize(telex_url)
      unless telex_url.start_with? "https://"
        raise ArgumentError, "Bad Url"
      end
      self.connection = Excon.new(telex_url,
        :headers => {
          "User-Agent" => "minitel/#{Minitel::VERSION} excon/#{Excon::VERSION}"
        }
      )
    end

    def notify_app(args)
      StrictArgs.enforce(args, [:app_uuid, :body, :title], :app_uuid)
      post_message('app', args[:app_uuid], args[:title], args[:body])
    end

    def notify_user(args)
      StrictArgs.enforce(args, [:user_uuid, :body, :title], :user_uuid)
      post_message('user', args[:user_uuid], args[:title], args[:body])
    end

    private

    def post_message(type, id, title, body)
      message = {
        title: title,
        body: body,
        target: {type: type, id: id}
      }

      response = connection.post(
                   path: "/producer/messages",
                   body: MultiJson.dump(message),
                   expects: 201)

      MultiJson.load(response.body)
    end
  end
end
