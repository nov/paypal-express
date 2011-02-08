module Paypal
  class Base
    include AttrRequired, AttrOptional, Util

    def initialize(attributes = {})
      if attributes.is_a?(Hash)
        (required_attributes + optional_attributes).each do |key|
          value = if numeric_attribute?(key)
            Util.to_numeric(attributes[key])
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