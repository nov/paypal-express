module Paypal
  module Payment
    class Response::Refund < Base
      attr_optional :transaction_id
      attr_accessor :amount

      def initialize(attributes = {})
        super
        @amount = Common::Amount.new(attributes[:amount])
      end
    end
  end
end