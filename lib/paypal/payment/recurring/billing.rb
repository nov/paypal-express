module Paypal
  module Payment
    class Recurring::Billing < Base
      attr_required :period, :frequency
      attr_optional :amount, :total_cycles, :trial_period, :trial_frequency, :trial_total_cycles, :trial_amount, :currency_code, :shipping_amount, :tax_amount

      def to_params
        {
          :BILLINGPERIOD => self.period,
          :BILLINGFREQUENCY => self.frequency,
          :TOTALBILLINGCYCLES => self.total_cycles,
          :AMT => Util.formatted_amount(self.amount),
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