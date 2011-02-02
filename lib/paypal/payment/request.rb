module Paypal
  module Payment
    class Request
      include AttrRequired
      attr_required :amount
      attr_accessor :action, :currency_code

      def initialize(attributes = {})
        @amount = attributes[:amount]
        @action = attributes[:action] || 'Sale'
        @currency_code = attributes[:currency_code] || 'USD'
      end

      def formatted_amount(amount)
        if amount.to_f == amount.to_i
          "#{amount.to_i}.00"
        else
          "#{amount.to_i}.#{((amount.to_f - amount.to_i) * 100).to_i}"
        end
      end

      def to_params(index = 0)
        {
          :"PAYMENTREQUEST_#{index}_PAYMENTACTION" => self.action,
          :"PAYMENTREQUEST_#{index}_AMT" => formatted_amount(self.amount),
          :"PAYMENTREQUEST_#{index}_CURRENCYCODE" => self.currency_code
        }
      end
    end
  end
end
