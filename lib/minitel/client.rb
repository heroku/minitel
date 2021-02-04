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
          "User-Agent" => "minitel/#{Minitel::VERSION} excon/#{Excon::VERSION}",
          "Content-Type" => "application/json"
        }
      )
    end

    def notify_app(args)
      StrictArgs.enforce(args, [:app_uuid, :body, :title], [:action], :app_uuid)
      if action = args[:action]
        StrictArgs.enforce(action, [:label, :url])
      end
      post_message('app', args[:app_uuid], args[:title], args[:body], action)
    end

    def notify_user(args)
      StrictArgs.enforce(args, [:user_uuid, :body, :title], [:action], :user_uuid)
      if action = args[:action]
        StrictArgs.enforce(action, [:label, :url])
      end
      post_message('user', args[:user_uuid], args[:title], args[:body], action)
    end

    def add_followup(args)
      StrictArgs.enforce(args, [:message_uuid, :body], [], :message_uuid)
      followup = { body: args[:body] }
      post("/producer/messages/#{args[:message_uuid]}/followups", followup)
    end

    private

    def post_message(type, id, title, body, action)
      message = {
        title: title,
        body: body,
        target: {type: type, id: id}
      }

      if action
        message.merge!(action: action)
      end

      post("/producer/messages", message)
    end

    def post(path, body)
      response = connection.post(
                   path: path,
                   body: MultiJson.dump(body),
                   expects: 201)

      MultiJson.load(response.body)
    end

  end
end
