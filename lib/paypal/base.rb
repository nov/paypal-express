module Paypal
  class Base
    include AttrRequired, AttrOptional

    def initialize(attributes = {})
      if attributes.is_a?(Hash)
        (required_attributes + optional_attributes).each do |key|
          self.send "#{key}=", attributes[key]
        end
      end
      attr_missing!
    end
  end
end