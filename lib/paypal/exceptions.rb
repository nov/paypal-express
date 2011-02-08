module Paypal

  class Exception < StandardError; end

  class HttpError < Exception
    attr_accessor :code, :message, :body
    def initialize(code, message, body = '')
      @code = code
      @message = message
      @body = body
    end
  end

  class APIError < Exception
    attr_accessor :response
    def initialize(response = {})
      @response = response
    end
  end

end