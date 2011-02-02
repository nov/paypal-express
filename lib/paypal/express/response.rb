module Paypal
  module Express
    class Response < NVP::Response
      def redirect_uri
        endpoint = if Paypal.sandbox?
          Paypal::ENDPOINT[:sandbox]
        else
          Paypal::ENDPOINT[:production]
        end
        endpoint = URI.parse endpoint
        endpoint.query = {
          :cmd => '_express-checkout',
          :token => self.token
        }.to_query
        endpoint.to_s
      end
    end
  end
end