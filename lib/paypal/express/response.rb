module Paypal
  module Express
    class Response < NVP::Response
      attr_accessor :pay_on_paypal, :mobile

      # Paypal::Express::Response.new()
      # response = {
      #   :ACK=>"Success",
      #   :BUILD=>"1721431",
      #   :CORRELATIONID=>"5549ea3a78af1",
      #   :TIMESTAMP=>"2011-02-02T02:02:18Z",
      #   :TOKEN=>"EC-5YJ90598G69065317",
      #   :VERSION=>"66.0"
      # }
      def initialize(response, options = {})
        super response
        @pay_on_paypal = options[:pay_on_paypal]
        @mobile        = options[:mobile]
      end

      def redirect_uri
        endpoint = URI.parse Paypal.endpoint
        endpoint.query = query(:with_cmd).to_query
        endpoint.to_s
      end

      def popup_uri
        endpoint = URI.parse Paypal.popup_endpoint
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
