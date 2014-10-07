require 'multi_json'
require 'excon'

module Minitel
  class Client
    attr_accessor :telex_url

    def initialize(telex_url)
      unless telex_url.start_with? "https://"
        raise ArgumentError, "Bad Url"
      end
      self.telex_url = telex_url
    end

    def notify_app(args)
      keywords = [:app_uuid, :body, :title]
      strict_args(args.keys, keywords)
      no_nils(args, keywords)

      title    = args.fetch(:title)
      body     = args.fetch(:body)
      app_uuid = args.fetch(:app_uuid)

      is_uuid(app_uuid)

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

    def no_nils(args, keys)
      keys.each do |key|
       raise ArgumentError, "keyword #{key} is nil" unless args[key]
      end
    end

    def is_uuid(uuid)
      unless uuid =~ /\A[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89ab][a-f0-9]{3}-[a-f0-9]{12}\z/i
        raise ArgumentError, "not formated like a uuid"
      end
    end
  end
end
