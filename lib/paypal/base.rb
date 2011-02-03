module Paypal
  class Base
    include AttrRequired, AttrOptional

    def initialize(*args)
      (required_attributes + optional_attributes).each do |key|
        self.send "#{key}=", attributes[key]
      end
      attr_missing!
    rescue AttrRequired::AttrMissing => e
      raise AttrMissing.new(e.message)
    end
  end
end