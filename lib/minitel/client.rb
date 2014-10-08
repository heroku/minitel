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
      keywords = [:app_uuid, :body, :title]
      app_uuid, body, title = args[:app_uuid], args[:body], args[:title]

      ensure_strict_args(args.keys, keywords)
      ensure_no_nils(args, keywords)
      ensure_is_uuid(app_uuid)

      message = {
        title: title,
        body: body,
        target: {type: 'app', id: app_uuid}
      }

      response = connection.post(
                   path: "/producer/messages",
                   body: MultiJson.dump(message),
                   expects: 201)

      MultiJson.load(response.body)
    end

    private

    # A Ruby 2.1 required keyword argument sorta backport
    def ensure_strict_args(keys, accept_keys)
      if keys.sort != accept_keys.sort
        delta = accept_keys - keys
        raise ArgumentError, "missing or extra keywords: #{delta.join(', ')}"
      end
    end

    def ensure_no_nils(args, keys)
      keys.each do |key|
       raise ArgumentError, "keyword #{key} is nil" unless args[key]
      end
    end

    def ensure_is_uuid(uuid)
      unless uuid =~ /\A[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}\z/i
        raise ArgumentError, "not formated like a uuid"
      end
    end

  end
end
