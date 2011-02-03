module Paypal
  module Payment
    class Response::Amount < Base
      attr_optional :total, :fee, :handing, :insurance, :ship_disc, :shipping, :tax
    end
  end
end