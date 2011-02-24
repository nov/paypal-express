module Paypal
  module Payment
    module Common
      class Amount < Base
        attr_optional :total, :fee, :handing, :insurance, :ship_disc, :shipping, :tax

        def numeric_attribute?(key)
          true
        end
      end
    end
  end
end