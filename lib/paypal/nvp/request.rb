module Paypal
  module NVP
    class Request < Base
      attr_required :username, :password
      attr_optional :subject, :certificate, :signature
      attr_accessor :version

      ENDPOINT = {
        :production => 'https://api-3t.paypal.com/nvp',
        :production_cert => 'https://api.paypal.com/nvp',
        :sandbox => 'https://api-3t.sandbox.paypal.com/nvp',
        :sandbox_cert => 'https://api.sandbox.paypal.com/nvp'
      }

      def self.endpoint
        if Paypal.sandbox?
          if Paypal.certificate_auth?
            ENDPOINT[:sandbox_cert]
          else
            ENDPOINT[:sandbox]
          end
        elsif Paypal.certificate_auth?
          ENDPOINT[:production_cert]
        else
          ENDPOINT[:production]
        end
      end

      def initialize(attributes = {})
        @version = Paypal.api_version
        super
      end

      def common_params
        params = {
          :USER => self.username,
          :PWD => self.password,
          :SIGNATURE => self.signature,
          :SUBJECT => self.subject,
          :VERSION => self.version
        }

        params.merge!(:SIGNATURE => self.signature) unless Paypal.certificate_auth
        params
      end

      def request(method, params = {})
        handle_response do
          post(method, params)
        end
      end

      private

      def post(method, params)
        request_params = {
          :method => :post, 
          :url => self.class.endpoint, 
          :payload => common_params.merge(params).merge(:METHOD => method)
        }

        request_params.merge!({
          :ssl_client_cert => OpenSSL::X509::Certificate.new(self.certificate),
          :ssl_client_key  => OpenSSL::PKey::RSA.new(self.certificate)
        }) if Paypal.certificate_auth?

        RestClient::Request.execute(request_params)
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
