module Paypal
  module Payment
    class Response
      attr_reader :amount, :insurance_option_offered, :currency_code, :error_code

      def initialize(attributes = {})
        @amount = Amount.new(
          :total => attributes[:AMT],
          :handing => attributes[:HANDLINGAMT],
          :insurance => attributes[:INSURANCEAMT],
          :ship_disc => attributes[:SHIPDISCAMT],
          :shipping => attributes[:SHIPPINGAMT],
          :tax => attributes[:TAXAMT]
        )
        @insurance_option_offered = attributes[:INSURANCEOPTIONOFFERED] == 'true'
        @currency_code = attributes[:CURRENCYCODE]
        @error_code = attributes[:ERRORCODE]
      end

      def to_request(overwritten = {})
        params = {
          :amount => self.amount.total,
          :currency_code => self.currency_code
        }.merge(overwritten)
        Request.new params
      end
    end
  end
end
