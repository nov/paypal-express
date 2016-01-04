module Paypal
  module Express
    class TransactionsResponse < NVP::TransactionsResponse

      def initialize(response, options = {})
        super response
      end

    end
  end
end