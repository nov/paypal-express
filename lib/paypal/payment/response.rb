module Paypal
  module Payment
    class Response < Base
      attr_accessor :amount, :ship_to, :description, :note, :items, :notify_url, :insurance_option_offered, :currency_code, :error_code, :transaction_id, :billing_agreement_id

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
          :street2 => attrs.delete(:SHIPTOSTREET2),
          :city => attrs.delete(:SHIPTOCITY),
          :state => attrs.delete(:SHIPTOSTATE),
          :country_code => attrs.delete(:SHIPTOCOUNTRYCODE),
          :country_name => attrs.delete(:SHIPTOCOUNTRYNAME)
        )
        @description = attrs.delete(:DESC)
        @note = attrs.delete(:NOTETEXT)
        @notify_url = attrs.delete(:NOTIFYURL)
        @insurance_option_offered = attrs.delete(:INSURANCEOPTIONOFFERED) == 'true'
        @currency_code = attrs.delete(:CURRENCYCODE)
        @error_code = attrs.delete(:ERRORCODE)
        @transaction_id = attrs.delete(:TRANSACTIONID)
        @billing_agreement_id = attrs.delete(:BILLINGAGREEMENTID)

        # items
        items = []
        attrs.keys.each do |_attr_|
          key, index = _attr_.to_s.scan(/^(.+?)(\d+)$/).flatten
          if index
            items[index.to_i] ||= {}
            items[index.to_i][key.to_sym] = attrs.delete(:"#{key}#{index}")
          end
        end
        @items = items.collect do |_attr_|
          Item.new(_attr_)
        end

        # warn ignored params
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end
