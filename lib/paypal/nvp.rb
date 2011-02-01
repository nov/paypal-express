module Paypal
  class NVP
    include AttrRequired, AttrOptional
    attr_required :username, :password, :signature, :version, :endpoint
    attr_optional :sandbox

    def initialize(attributes = {})
      @username = attributes[:username]
      @password = attributes[:password]
      @signature = attributes[:signature]
      @sandbox = attributes[:sandbox]
      @version = '66.0'
      @endpoint = if @sandbox
        'https://api-3t.sandbox.paypal.com/nvp'
      else
        'https://api-3t.paypal.com/nvp'
      end
    end

    def common_params
      {
        :USER => self.username,
        :PWD => self.password,
        :SIGNATURE => self.signature,
        :VERSION => self.version
      }
    end

    def request(method, params = {})
      attr_missing!
      response = RestClient.post(
        self.endpoint,
        common_params.merge(params).merge(:METHOD => method)
      )
      response = CGI.parse(response).inject({}) do |res, (k, v)|
        res.merge!(k.to_sym => v.first)
      end
      case response[:ACK]
      when 'Success', 'SuccessWithWarning'
        response
      else
        raise APIError.new(response)
      end
    rescue AttrRequired::AttrMissing => e
      raise AttrMissing.new(e.message)
    rescue RestClient::Exception => e
      raise Exception.new(e.http_code, e.message, e.http_body)
    end
  end
end