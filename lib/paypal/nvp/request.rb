module Paypal
  module NVP
    class Request < Base
      attr_required :username, :password, :signature
      attr_optional :subject
      attr_accessor :version

      ENDPOINT = {
        :production => 'https://api-3t.paypal.com/nvp',
        :sandbox => 'https://api-3t.sandbox.paypal.com/nvp'
      }

      def self.endpoint
        if Paypal.sandbox?
          ENDPOINT[:sandbox]
        else
          ENDPOINT[:production]
        end
      end

      def initialize(attributes = {})
        @version = Paypal.api_version
        super
      end

      def common_params
        {
          :USER => self.username,
          :PWD => self.password,
          :SIGNATURE => self.signature,
          :SUBJECT => self.subject,
          :VERSION => self.version
        }
      end

      def request(method, params = {})
        handle_response do
          post(method, params)
        end
      end

      private

      def post(method, params)
        RestClient.post(self.class.endpoint, common_params.merge(params).merge(:METHOD => method))
      end

      def handle_response
        response = yield
        response = CGI.parse(response).inject({}) do |res, (k, v)|
          res.merge!(k.to_sym => v.first)
        end
        case response[:ACK]
        when 'Success', 'SuccessWithWarning'
          response
        else
          raise Exception::APIError.new(response)
        end
      rescue RestClient::Exception => e
        raise Exception::HttpError.new(e.http_code, e.message, e.http_body)
      end
    end
  end
end