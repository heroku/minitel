# frozen_string_literal: true

module Minitel
  module HTTP
    class Error < StandardError; end
    class ClientError < Error; end
    class NotFound < ClientError; end
    class TooManyRequests < ClientError; end
    class ServerError < Error; end
  end
end
