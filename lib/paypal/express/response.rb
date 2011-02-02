module Paypal
  class Express::Response < NVP::Response

    def redirect_uri
      endpoint = URI.parse Paypal::ENDPOINT
      endpoint.query = {
        :cmd = '_express-checkout',
        :token => self.token
      }
      endpoint.to_s
    end

  end
end