module Paypal
  module Payment
    class Response < Base
      attr_reader :amount, :ship_to, :insurance_option_offered, :currency_code, :error_code

      def initialize(attributes = {})
        attrs = attributes.dup
        @amount = Amount.new(
          :total => attrs.delete(:AMT),
          :handing => attrs.delete(:HANDLINGAMT),
          :insurance => attrs.delete(:INSURANCEAMT),
          :ship_disc => attrs.delete(:SHIPDISCAMT),
          :shipping => attrs.delete(:SHIPPINGAMT),
          :tax => attrs.delete(:TAXAMT)
        )
        @ship_to = Payment::Response::ShipTo.new(
          :name => attrs.delete(:SHIPTONAME),
          :zip => attrs.delete(:SHIPTOZIP),
          :street => attrs.delete(:SHIPTOSTREET),
          :city => attrs.delete(:SHIPTOCITY),
          :state => attrs.delete(:SHIPTOSTATE),
          :country_code => attrs.delete(:SHIPTOCOUNTRYCODE),
          :country_name => attrs.delete(:SHIPTOCOUNTRYNAME)
        )
        @insurance_option_offered = attrs.delete(:INSURANCEOPTIONOFFERED) == 'true'
        @currency_code = attrs.delete(:CURRENCYCODE)
        @error_code = attrs.delete(:ERRORCODE)

        # warn ignored params
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
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
