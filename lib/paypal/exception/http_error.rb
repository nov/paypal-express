module Paypal
  class Exception
    class HttpError < Exception
      attr_accessor :code, :message, :body
      def initialize(code, message, body = '')
        @code = code
        @message = message
        @body = body
      end
    end
  end
end