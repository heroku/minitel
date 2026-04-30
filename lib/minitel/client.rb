# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

module Minitel
  class Client
    attr_reader :uri, :user, :password

    def initialize(telex_url)
      unless telex_url.start_with? "https://"
        raise ArgumentError, "Bad Url"
      end
      @uri = URI.parse(telex_url)
      @user = @uri.user
      @password = @uri.password
    end

    def notify_app(args)
      StrictArgs.enforce(args, [:app_uuid, :body, :title], [:action], :app_uuid)
      if (action = args[:action])
        StrictArgs.enforce(action, [:label, :url])
      end
      post_message("app", args[:app_uuid], args[:title], args[:body], action)
    end

    def notify_user(args)
      StrictArgs.enforce(args, [:user_uuid, :body, :title], [:action], :user_uuid)
      if (action = args[:action])
        StrictArgs.enforce(action, [:label, :url])
      end
      post_message("user", args[:user_uuid], args[:title], args[:body], action)
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
        target: { type: type, id: id },
      }

      if action
        message.merge!(action: action)
      end

      post("/producer/messages", message)
    end

    def post(path, body)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(path)
      request.basic_auth(user, password)
      request["Content-Type"] = "application/json"
      request["User-Agent"] = "minitel/#{Minitel::VERSION}"
      request.body = JSON.generate(body)

      response = http.request(request)
      unless response.code == "201"
        raise error_class_for_status(response.code.to_i), "Expected 201, got #{response.code}"
      end
      JSON.parse(response.body)
    end

    def error_class_for_status(code)
      case code
      when 404 then HTTP::NotFound
      when 429 then HTTP::TooManyRequests
      when 400..499 then HTTP::ClientError
      when 500..599 then HTTP::ServerError
      else HTTP::Error
      end
    end
  end
end
