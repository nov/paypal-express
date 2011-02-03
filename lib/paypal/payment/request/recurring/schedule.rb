module Paypal
  module Payment
    class Request::Recurring::Schedule < Base
      attr_required :description
      attr_optional :max_fails, :auto_bill

      def to_params
        {
          :DESC  => self.description,
          :MAXFAILEDPAYMENTS => self.max_fails,
          :AUTOBILLAMT => self.auto_bill
        }
      end
    end
  end
end