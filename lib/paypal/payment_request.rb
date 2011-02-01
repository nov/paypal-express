class Paypal
  class PaymentRequest
    attr_required :payment_action, :amount
    attr_optional :transaction_id, :transaction_type, :payment_type, :order_time, :currency_code, :tax_amount, :payment_status, :pending_reason, :reason_code

    def initialize(attributes = {})
      (required_attributes + optional_attributes).each do |key|
        self.send "#{key}=", attributes[key]
      end
      @payment_action ||= 'Sale'
      @amount ||= 0
      @currency_code ||= 'USD'
    end

    def formatted_amount(amount)
      if amount == amount.to_i
        "#{amount.to_i}.00"
      else
        "#{amount.to_i}.#{((amount - amount.to_i) * 100).to_i}"
      end
    end

    def to_params(index = 0)
      {
        :"PAYMENTREQUEST_#{index}_PAYMENTACTION" => self.payment_action,
        :"PAYMENTREQUEST_#{index}_AMT" => formatted_amount(self.amount),
        :"PAYMENTREQUEST_#{index}_CURRENCYCODE" => self.currency_code
      }
    end

  end
end
