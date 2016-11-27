module Paypal
  module Payment
    class Response::Transaction < Base
      # https://developer.paypal.com/docs/classic/api/merchant/TransactionSearch_API_Operation_NVP/
      cattr_reader :attribute_mapping
      @@attribute_mapping = {
        :TIMESTAMP => :timestamp,
        :TIMEZONE => :timezone,
        :TYPE => :type,
        :EMAIL => :email,
        :NAME => :name,
        :TRANSACTIONID => :transaction_id,
        :STATUS => :status,
        :AMT => :amount,
        :CURRENCYCODE => :currency_code,
        :FEEAMT => :fee_amount,
        :NETAMT => :net_amount
      }
      attr_accessor *@@attribute_mapping.values

      def initialize(attributes = {})
        attrs = attributes.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end

        # warn ignored params
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end
