module Paypal
  module Payment
    class Recurring::Billing < Base
      attr_optional :period, :frequency, :paid, :currency_code, :total_cycles
      attr_accessor :amount, :trial

      def initialize(attributes = {})
        @amount = if attributes[:amount].is_a?(Common::Amount)
          attributes[:amount]
        else
          Common::Amount.new(
            :total => attributes[:amount],
            :tax => attributes[:tax_amount],
            :shipping => attributes[:shipping_amount]
          )
        end
        @trial = Recurring::Billing.new(attributes[:trial]) if attributes[:trial].present?
        super
      end

      def to_params
        trial_params = (trial.try(:to_params) || {}).inject({}) do |trial_params, (key, value)|
          trial_params.merge(
            :"TRIAL#{key}" => value
          )
        end
        trial_params.merge(
          :BILLINGPERIOD => self.period,
          :BILLINGFREQUENCY => self.frequency,
          :TOTALBILLINGCYCLES => self.total_cycles,
          :AMT => Util.formatted_amount(self.amount.total),
          :CURRENCYCODE => self.currency_code,
          :SHIPPINGAMT => Util.formatted_amount(self.amount.shipping),
          :TAXAMT => Util.formatted_amount(self.amount.tax)
        )
      end
    end
  end
end