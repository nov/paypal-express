module Paypal
  module NVP
    class Request < Base
      attr_required :username, :password, :signature
      attr_reader :version, :endpoint

      ENDPOINT = {
        :production => 'https://api-3t.paypal.com/nvp',
        :sandbox => 'https://api-3t.sandbox.paypal.com/nvp'
      }

      def initialize(attributes = {})
        @version = API_VERSION
        @endpoint = if Paypal.sandbox?
          ENDPOINT[:sandbox]
        else
          ENDPOINT[:production]
        end
        super
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
        handle_response do
          post(method, params)
        end
      end

      private

      def post(method, params)
        RestClient.post(self.endpoint, common_params.merge(params).merge(:METHOD => method))
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
          raise APIError.new(response)
        end
      rescue RestClient::Exception => e
        raise Exception.new(e.http_code, e.message, e.http_body)
      end
    end
  end
end