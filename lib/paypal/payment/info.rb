module Paypal
  module Payment
    class Info
      @@attribute_mapping = {
        :ACK => :ack,
        :CURRENCYCODE => :currency_code,
        :ERRORCODE => :error_code,
        :ORDERTIME => :order_time,
        :PAYMENTSTATUS => :payment_status,
        :PAYMENTTYPE => :payment_type,
        :PENDINGREASON => :pending_reason,
        :PROTECTIONELIGIBILITY => :protection_eligibility,
        :PROTECTIONELIGIBILITYTYPE => :protection_eligibility_type,
        :REASONCODE => :reason_code,
        :TRANSACTIONID => :transaction_id,
        :TRANSACTIONTYPE => :transaction_type
      }
      attr_accessor *@@attribute_mapping.values
      attr_reader :amount, :currency_code

      def initialize(attributes = {})
        attrs = attributes.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end
        @amount = Response::Amount.new(
          :total => attrs.delete(:AMT),
          :fee => attrs.delete(:FEEAMT),
          :tax => attrs.delete(:TAXAMT)
        )

        # warn ignored params
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter: #{key}=#{value}", :warn
        end
      end
    end
  end
end