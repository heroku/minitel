module Minitel
  module StrictArgs
    extend self
    def enforce(args, required, allowed=[], uuid_field=nil)
      ensure_strict_args(args.keys, required, allowed)
      ensure_no_nils(args, required)
      ensure_is_uuid(args[uuid_field]) if uuid_field
    end

    # A Ruby 2.1 required keyword argument sorta backport
    def ensure_strict_args(keys, required, allowed)
      missing = required - keys
      unless missing.empty?
        raise ArgumentError, "missing keywords: #{missing.join(', ')}"
      end
      unknown = keys - (required + allowed)
      unless unknown.empty?
        raise ArgumentError, "extra keywords: #{unknown.join(', ')}"
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
