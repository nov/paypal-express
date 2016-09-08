module Paypal
  module Express
    class Response < NVP::Response
      attr_accessor :pay_on_paypal, :mobile, :environment

      def initialize(response, options = {})
        super response
        @pay_on_paypal = options[:pay_on_paypal]
        @mobile        = options[:mobile]

        if options[:environment]
          @environment = (options[:environment] == :production) ? :production : :sandbox
        else
          @environment = nil
        end
      end

      def redirect_uri
        endpoint = URI.parse(Paypal.endpoint(environment))
        endpoint.query = query(:with_cmd).to_query
        endpoint.to_s
      end

      def popup_uri
        endpoint = URI.parse(Paypal.popup_endpoint(environment))
        endpoint.query = query.to_query
        endpoint.to_s
      end

      private

      def query(with_cmd = false)
        _query_ = {:token => self.token}
        _query_.merge!(:cmd => '_express-checkout')        if with_cmd
        _query_.merge!(:cmd => '_express-checkout-mobile') if mobile
        _query_.merge!(:useraction => 'commit')            if pay_on_paypal
        _query_
      end
    end
  end
end
