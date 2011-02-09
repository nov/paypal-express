module Paypal
  module Express
    class Response < NVP::Response
      def redirect_uri
        endpoint = URI.parse Paypal.endpoint
        endpoint.query = {
          :cmd => '_express-checkout',
          :token => self.token
        }.to_query
        endpoint.to_s
      end
    end
  end
end