module Paypal
  class Base
    include AttrRequired, AttrOptional, Util

    def initialize(attributes = {})
      if attributes.is_a?(Hash)
        (required_attributes + optional_attributes).each do |key|
          value = if numeric_attributes?(key)
            Util.numeric_amount(attributes[key])
          else
            attributes[key]
          end
          self.send "#{key}=", value
        end
      end
      attr_missing!
    end
  end
end