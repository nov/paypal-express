module Paypal
  module Payment
    class Recurring::Summary < Base
      attr_optional :next_billing_date, :cycles_completed, :cycles_remaining, :outstanding_balance, :failed_count, :last_payment_date, :last_payment_amount
    end
  end
end