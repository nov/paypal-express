module Paypal
  module Payment
    class Recurring::Billing < Base
      attr_required :period, :frequency
      attr_optional :paid, :currency_code, :total_cycles, :trial_period, :trial_frequency, :trial_total_cycles, :trial_amount, :trial_amount_paid
      attr_reader :amount

      def initialize(attributes = {})
        attributes[:amount] ||= {}
        @amount = if attributes[:amount].is_a?(Response::Amount)
          attributes[:amount]
        else
          Response::Amount.new(
            :total => attributes[:amount],
            :tax => attributes[:tax_amount],
            :shipping => attributes[:shipping_amount]
          )
        end
        super
      end

      def to_params
        {
          :BILLINGPERIOD => self.period,
          :BILLINGFREQUENCY => self.frequency,
          :TOTALBILLINGCYCLES => self.total_cycles,
          :AMT => Util.formatted_amount(self.amount.total),
          :TRIALBILLINGPERIOD => self.trial_period,
          :TRIALBILLINGFREQUENCY => self.trial_frequency,
          :TRIALTOTALBILLINGCYCLES => self.trial_total_cycles,
          :TRIALAMT => Util.formatted_amount(self.trial_amount),
          :CURRENCYCODE => self.currency_code,
          :SHIPPINGAMT => Util.formatted_amount(self.shipping_amount),
          :TAXAMT => Util.formatted_amount(self.tax_amount)
        }
      end
    end
  end
end