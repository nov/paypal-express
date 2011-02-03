module Paypal
  module Recurring
    class Activation < Base
      attr_optional :initial_amount, :failed_action
    end
  end
end