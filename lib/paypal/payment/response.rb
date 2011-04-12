module Paypal
  module Payment
    class Response < Base
      attr_accessor :amount, :ship_to, :description, :notify_url, :insurance_option_offered, :currency_code, :error_code

      def initialize(attributes = {})
        attrs = attributes.dup
        @amount = Common::Amount.new(
          :total => attrs.delete(:AMT),
          :item => attrs.delete(:ITEMAMT),
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
        @description = attrs.delete(:DESC)
        @notify_url = attrs.delete(:NOTIFYURL)
        @insurance_option_offered = attrs.delete(:INSURANCEOPTIONOFFERED) == 'true'
        @currency_code = attrs.delete(:CURRENCYCODE)
        @error_code = attrs.delete(:ERRORCODE)

        # items
        

        # warn ignored params
        p attrs
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end
