module Paypal
  module NVP
    class Response
      @@attribute_mapping = {
        :ACK => :ack,
        :ADDRESSSTATUS => :address_status,
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
      attr_accessor :amount, :payer, :ship_to, :payment_responses, :payment_info

      def initialize(response_params = {})
        params = response_params.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", params.delete(key)
        end
        @shipping_options_is_default = params.delete(:SHIPPINGOPTIONISDEFAULT) == 'true'
        @success_page_redirect_requested = params.delete(:SUCCESSPAGEREDIRECTREQUESTED) == 'true'
        @insurance_option_selected = params.delete(:INSURANCEOPTIONSELECTED) == 'true'
        @amount = Payment::Response::Amount.new(
          :total => params.delete(:AMT),
          :handing => params.delete(:HANDLINGAMT),
          :insurance => params.delete(:INSURANCEAMT),
          :ship_disc => params.delete(:SHIPDISCAMT),
          :shipping => params.delete(:SHIPPINGAMT),
          :tax => params.delete(:TAXAMT)
        )
        @payer = Payment::Response::Payer.new(
          :identifier => params.delete(:PAYERID),
          :status => params.delete(:PAYERSTATUS),
          :first_name => params.delete(:FIRSTNAME),
          :last_name => params.delete(:LASTNAME),
          :email => params.delete(:EMAIL)
        )
        @ship_to = Payment::Response::ShipTo.new(
          :name => params.delete(:SHIPTONAME),
          :zip => params.delete(:SHIPTOZIP),
          :street => params.delete(:SHIPTOSTREET),
          :city => params.delete(:SHIPTOCITY),
          :state => params.delete(:SHIPTOSTATE),
          :country_code => params.delete(:SHIPTOCOUNTRYCODE),
          :country_name => params.delete(:SHIPTOCOUNTRYNAME)
        )

        # payment_responses
        payment_responses = []
        params.keys.each do |attribute|
          prefix, index, key = attribute.to_s.split('_')
          case prefix
          when 'PAYMENTREQUEST', 'PAYMENTREQUESTINFO'
            payment_responses[index.to_i] ||= {}
            payment_responses[index.to_i][key.to_sym] = params.delete(attribute)
          end
        end
        @payment_responses = payment_responses.collect do |payment_response_attributes|
          Payment::Response.new payment_response_attributes
        end

        # payment_info
        payment_info = []
        params.keys.each do |attribute|
          prefix, index, key = attribute.to_s.split('_')
          if prefix == 'PAYMENTINFO'
            payment_info[index.to_i] ||= {}
            payment_info[index.to_i][key.to_sym] = params.delete(attribute)
          end
        end
        @payment_info = payment_info.collect do |payment_info_attributes|
          Payment::Info.new payment_response_attributes
        end

        # warn ignored params
        params.each do |key, value|
          Paypal.log "Ignored Parameter: #{key}=#{value}", :warn
        end
      end
    end
  end
end