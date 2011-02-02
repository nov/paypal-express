module Paypal
  module Payment
    class Response::Amount
      attr_reader :total, :fee, :handing, :insurance, :ship_disc, :shipping, :tax

      def initialize(attributes = {})
        @total = attributes[:total]
        @fee = attributes[:fee]
        @handing = attributes[:handing]
        @insurance = attributes[:insurance]
        @ship_disc = attributes[:ship_disc]
        @shipping = attributes[:shipping]
        @tax = attributes[:tax]
      end
    end
  end
end