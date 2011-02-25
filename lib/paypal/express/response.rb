module Paypal
  module Express
    class Response < NVP::Response
      attr_accessor :on_mobile, :pay_on_paypal

      def initialize(response, options = {})
        super response
        @on_mobile = options[:on_mobile]
        @pay_on_paypal = options[:pay_on_paypal]
      end

      def redirect_uri
        endpoint = URI.parse Paypal.endpoint
        endpoint.query = query(:redirect).to_query
        endpoint.to_s
      end

      def popup_uri
        endpoint = URI.parse Paypal.popup_endpoint
        endpoint.query = query(:popup).to_query
        endpoint.to_s
      end

      private

      def query(mode)
        _query_ = {:token => self.token}
        case mode
        when :redirect
          if self.on_mobile
            _query_.merge!(:cmd => '_express-checkout-mobile')
          else
            _query_.merge!(:cmd => '_express-checkout')
          end
        when :popup
          # No popup specific params for now
        end
        if self.pay_on_paypal
          _query_.merge!(:useraction => 'commit')
        end
        _query_
      end
    end
  end
end