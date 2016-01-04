module Paypal
  module Express
    class TransactionsResponse < NVP::Response

      def initialize(response, options = {})
        super response
      end

    end
  end
end