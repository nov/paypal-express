module Paypal
  class Express < NVP
    attr_required :return_url, :cancel_url

    def initialize(attributes = {})
      super
      @return_url = attributes[:return_url]
      @cancel_url = attributes[:cancel_url]
    end

    def setup(payment_requests = [])
      params = {
        :RETURNURL => self.return_url,
        :CANCELURL => self.cancel_url
      }
      payment_requests.each_with_index do |payment_request, index|
        params.merge! payment_request.to_params(index)
      end
      response = self.request :SetExpressCheckout, params
      if response['ACK']
      end
    end

  end
end