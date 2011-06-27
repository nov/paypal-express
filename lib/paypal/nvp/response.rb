module Paypal
  module NVP
    class Response < Base
      cattr_reader :attribute_mapping
      @@attribute_mapping = {
        :ACK => :ack,
        :ADDRESSSTATUS => :address_status,
        :BILLINGAGREEMENTACCEPTEDSTATUS => :billing_agreement_accepted_status,
        :BUILD => :build,
        :CHECKOUTSTATUS => :checkout_status,
        :CORRELATIONID => :colleration_id,
        :COUNTRYCODE => :country_code,
        :CURRENCYCODE => :currency_code,
        :DESC => :description,
        :NOTIFYURL => :notify_url,
        :TIMESTAMP => :timestamp,
        :TOKEN => :token,
        :VERSION => :version,
        :BILLINGAGREEMENTID => :billing_agreement_id
      }
      attr_accessor *@@attribute_mapping.values
      attr_accessor :shipping_options_is_default, :success_page_redirect_requested, :insurance_option_selected
      attr_accessor :amount, :description, :ship_to, :payer, :recurring, :payment_responses, :payment_info, :items, :refund

      def initialize(attributes = {})
        attrs = attributes.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end
        @shipping_options_is_default = attrs.delete(:SHIPPINGOPTIONISDEFAULT) == 'true'
        @success_page_redirect_requested = attrs.delete(:SUCCESSPAGEREDIRECTREQUESTED) == 'true'
        @insurance_option_selected = attrs.delete(:INSURANCEOPTIONSELECTED) == 'true'
        @amount = Payment::Common::Amount.new(
          :total => attrs.delete(:AMT),
          :item => attrs.delete(:ITEMAMT),
          :handing => attrs.delete(:HANDLINGAMT),
          :insurance => attrs.delete(:INSURANCEAMT),
          :ship_disc => attrs.delete(:SHIPDISCAMT),
          :shipping => attrs.delete(:SHIPPINGAMT),
          :tax => attrs.delete(:TAXAMT)
        )
        @ship_to = Payment::Response::ShipTo.new(
          :owner => attrs.delete(:SHIPADDRESSOWNER),
          :status => attrs.delete(:SHIPADDRESSSTATUS),
          :name => attrs.delete(:SHIPTONAME),
          :zip => attrs.delete(:SHIPTOZIP),
          :street => attrs.delete(:SHIPTOSTREET),
          :street2 => attrs.delete(:SHIPTOSTREET2),
          :city => attrs.delete(:SHIPTOCITY),
          :state => attrs.delete(:SHIPTOSTATE),
          :country_code => attrs.delete(:SHIPTOCOUNTRYCODE),
          :country_name => attrs.delete(:SHIPTOCOUNTRYNAME)
        )
        if attrs[:PAYERID]
          @payer = Payment::Response::Payer.new(
            :identifier => attrs.delete(:PAYERID),
            :status => attrs.delete(:PAYERSTATUS),
            :first_name => attrs.delete(:FIRSTNAME),
            :last_name => attrs.delete(:LASTNAME),
            :email => attrs.delete(:EMAIL)
          )
        end
        if attrs[:REFUNDTRANSACTIONID]
          @refund = Payment::Response::Refund.new(
            :transaction_id => attrs.delete(:REFUNDTRANSACTIONID),
            :amount => {
              :total => attrs.delete(:TOTALREFUNDEDAMOUNT),
              :fee => attrs.delete(:FEEREFUNDAMT),
              :gross => attrs.delete(:GROSSREFUNDAMT),
              :net => attrs.delete(:NETREFUNDAMT)
            }
          )
        end
        if attrs[:PROFILEID]
          @recurring = Payment::Recurring.new(
            :identifier => attrs.delete(:PROFILEID),
            # NOTE:
            #  CreateRecurringPaymentsProfile returns PROFILESTATUS
            #  GetRecurringPaymentsProfileDetails returns STATUS
            :description => @description,
            :status => attrs.delete(:STATUS) || attrs.delete(:PROFILESTATUS),
            :start_date => attrs.delete(:PROFILESTARTDATE),
            :name => attrs.delete(:SUBSCRIBERNAME),
            :reference => attrs.delete(:PROFILEREFERENCE),
            :auto_bill => attrs.delete(:AUTOBILLOUTAMT),
            :max_fails => attrs.delete(:MAXFAILEDPAYMENTS),
            :aggregate_amount => attrs.delete(:AGGREGATEAMT),
            :aggregate_optional_amount => attrs.delete(:AGGREGATEOPTIONALAMT),
            :final_payment_date => attrs.delete(:FINALPAYMENTDUEDATE)
          )
          if attrs[:BILLINGPERIOD]
            @recurring.billing = Payment::Recurring::Billing.new(
              :amount => @amount,
              :currency_code => @currency_code,
              :period => attrs.delete(:BILLINGPERIOD),
              :frequency => attrs.delete(:BILLINGFREQUENCY),
              :total_cycles => attrs.delete(:TOTALBILLINGCYCLES),
              :trial_amount_paid => attrs.delete(:TRIALAMTPAID)
            )
          end
          if attrs[:REGULARAMT]
            @recurring.regular_billing = Payment::Recurring::Billing.new(
              :amount => attrs.delete(:REGULARAMT),
              :shipping_amount => attrs.delete(:REGULARSHIPPINGAMT),
              :tax_amount => attrs.delete(:REGULARTAXAMT),
              :currency_code => attrs.delete(:REGULARCURRENCYCODE),
              :period => attrs.delete(:REGULARBILLINGPERIOD),
              :frequency => attrs.delete(:REGULARBILLINGFREQUENCY),
              :total_cycles => attrs.delete(:REGULARTOTALBILLINGCYCLES),
              :paid => attrs.delete(:REGULARAMTPAID)
            )
            @recurring.summary = Payment::Recurring::Summary.new(
              :next_billing_date => attrs.delete(:NEXTBILLINGDATE),
              :cycles_completed => attrs.delete(:NUMCYCLESCOMPLETED),
              :cycles_remaining => attrs.delete(:NUMCYCLESREMAINING),
              :outstanding_balance => attrs.delete(:OUTSTANDINGBALANCE),
              :failed_count => attrs.delete(:FAILEDPAYMENTCOUNT),
              :last_payment_date => attrs.delete(:LASTPAYMENTDATE),
              :last_payment_amount => attrs.delete(:LASTPAYMENTAMT)
            )
          end
        end

        # payment_responses
        payment_responses = []
        attrs.keys.each do |_attr_|
          prefix, index, key = case _attr_.to_s
          when /^PAYMENTREQUEST/, /^PAYMENTREQUESTINFO/
            _attr_.to_s.split('_')
          when /^L_PAYMENTREQUEST/
            _attr_.to_s.split('_')[1..-1]
          end
          if prefix
            payment_responses[index.to_i] ||= {}
            payment_responses[index.to_i][key.to_sym] = attrs.delete(_attr_)
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

        # payment_info
        items = []
        attrs.keys.each do |_attr_|
          key, index = _attr_.to_s.scan(/^L_(.+)(\d)$/).flatten
          if index
            items[index.to_i] ||= {}
            items[index.to_i][key.to_sym] = attrs.delete(_attr_)
          end
        end
        @items = items.collect do |_attrs_|
          Payment::Response::Item.new _attrs_
        end

        # remove duplicated parameters
        attrs.delete(:SHIPTOCOUNTRY) # NOTE: Same with SHIPTOCOUNTRYCODE

        # warn ignored attrs
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end
