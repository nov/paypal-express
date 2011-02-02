module Paypal
  module Payment
    class Response::Amount
      attr_reader :total, :handing, :insurance, :ship_disc, :shipping, :tax

      def initialize(attributes = {})
        @total = attributes[:total]
        @handing = attributes[:handing]
        @insurance = attributes[:insurance]
        @ship_disc = attributes[:ship_disc]
        @shipping = attributes[:shipping]
        @tax = attributes[:tax]
      end
    end
  end
end