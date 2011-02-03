module Paypal
  module Payment
    class Recurring::Activation < Base
      attr_optional :initial_amount, :failed_action

      def to_params
        {
          :INITAMT => Util.formatted_amount(self.initial_amount),
          :FAILEDINITAMTACTION => self.failed_action
        }
      end
    end
  end
end