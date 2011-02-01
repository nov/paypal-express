module Paypal

  class Exception < StandardError; end
  class AttrMissing < Exception; end

  class HttpError < Exception
    attr_accessor :code, :type, :message
    def initialize(code, message, body = '')
      @code = code
      if body.blank?
        @message = message
      else
        response = JSON.parse(body).with_indifferent_access
        @message = response[:error][:message]
        @type = response[:error][:type]
      end
    end
  end

  class APIError < Exception
    attr_accessor :response
    def initialize(response = {})
      @response = response
    end
  end

end