module Paypal
  module Payment
    class Response::Recurring < Base
      attr_optional :identifier, :status
    end
  end
end