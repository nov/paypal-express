module Paypal
  module Payment
    class Response::Info < Base
      cattr_reader :attribute_mapping
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
        :RECEIPTID => :receipt_id,
        :SECUREMERCHANTACCOUNTID => :secure_merchant_account_id,
        :TRANSACTIONID => :transaction_id,
        :TRANSACTIONTYPE => :transaction_type,
        :PAYMENTREQUESTID => :request_id,
        :SELLERPAYPALACCOUNTID => :seller_id
      }
      attr_accessor *@@attribute_mapping.values
      attr_accessor :amount

      def initialize(attributes = {})
        attrs = attributes.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end
        @amount = Common::Amount.new(
          :total => attrs.delete(:AMT),
          :fee => attrs.delete(:FEEAMT),
          :tax => attrs.delete(:TAXAMT)
        )

        # warn ignored params
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end