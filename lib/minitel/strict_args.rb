module Minitel
  module StrictArgs
    extend self
    def enforce(args, keywords, uuid_field)
      ensure_strict_args(args.keys, keywords)
      ensure_no_nils(args, keywords)
      ensure_is_uuid(args[uuid_field])
    end

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
        raise ArgumentError, "'#{uuid.inspect}' not formated like a uuid"
      end
    end
  end
end
