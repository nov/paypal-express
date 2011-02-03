module Paypal
  module NVP
    class Response < Base
      @@attribute_mapping = {
        :ACK => :ack,
        :ADDRESSSTATUS => :address_status,
        :BILLINGAGREEMENTACCEPTEDSTATUS => :billing_agreement_accepted_status,
        :BUILD => :build,
        :CHECKOUTSTATUS => :checkout_status,
        :CORRELATIONID => :colleration_id,
        :COUNTRYCODE => :country_code,
        :CURRENCYCODE => :currency_code,
        :TIMESTAMP => :timestamp,
        :TOKEN => :token,
        :VERSION => :version
      }
      attr_accessor *@@attribute_mapping.values
      attr_accessor :shipping_options_is_default, :success_page_redirect_requested, :insurance_option_selected
      attr_accessor :amount, :payer, :ship_to, :recurring_profile, :payment_responses, :payment_info

      def initialize(attributes = {})
        attrs = attributes.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end
        @shipping_options_is_default = attrs.delete(:SHIPPINGOPTIONISDEFAULT) == 'true'
        @success_page_redirect_requested = attrs.delete(:SUCCESSPAGEREDIRECTREQUESTED) == 'true'
        @insurance_option_selected = attrs.delete(:INSURANCEOPTIONSELECTED) == 'true'
        @amount = Payment::Response::Amount.new(
          :total => attrs.delete(:AMT),
          :handing => attrs.delete(:HANDLINGAMT),
          :insurance => attrs.delete(:INSURANCEAMT),
          :ship_disc => attrs.delete(:SHIPDISCAMT),
          :shipping => attrs.delete(:SHIPPINGAMT),
          :tax => attrs.delete(:TAXAMT)
        )
        @payer = Payment::Response::Payer.new(
          :identifier => attrs.delete(:PAYERID),
          :status => attrs.delete(:PAYERSTATUS),
          :first_name => attrs.delete(:FIRSTNAME),
          :last_name => attrs.delete(:LASTNAME),
          :email => attrs.delete(:EMAIL)
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
        @recurring = Payment::Response::Recurring.new(
          :identifier => attrs.delete(:PROFILEID),
          :status => attrs.delete(:PROFILESTATUS)
        )

        # payment_responses
        payment_responses = []
        attrs.keys.each do |attribute|
          prefix, index, key = attribute.to_s.split('_')
          case prefix
          when 'PAYMENTREQUEST', 'PAYMENTREQUESTINFO'
            payment_responses[index.to_i] ||= {}
            payment_responses[index.to_i][key.to_sym] = attrs.delete(attribute)
          end
        end
        @payment_responses = payment_responses.collect do |_attrs_|
          Payment::Response.new _attrs_
        end

        # payment_info
        payment_info = []
        attrs.keys.each do |_attr_|
          prefix, index, key = _attr_.to_s.split('_')
          if prefix == 'PAYMENTINFO'
            payment_info[index.to_i] ||= {}
            payment_info[index.to_i][key.to_sym] = attrs.delete(_attr_)
          end
        end
        @payment_info = payment_info.collect do |_attrs_|
          Payment::Response::Info.new _attrs_
        end

        # warn ignored attrs
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end