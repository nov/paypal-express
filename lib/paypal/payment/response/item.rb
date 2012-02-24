module Paypal
  module Payment
    class Response::Item < Base
      cattr_reader :attribute_mapping
      @@attribute_mapping = {
        :NAME => :name,
        :DESC => :description,
        :QTY => :quantity,
        :NUMBER => :number,
        :ITEMCATEGORY => :category,
        :ITEMWIDTHVALUE => :width,
        :ITEMHEIGHTVALUE => :height,
        :ITEMLENGTHVALUE => :length,
        :ITEMWEIGHTVALUE => :weight
      }
      attr_accessor *@@attribute_mapping.values
      attr_accessor :amount

      def initialize(attributes = {})
        attrs = attributes.dup
        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end
        @quantity = @quantity.to_i
        @amount = Common::Amount.new(
          :total => attrs.delete(:AMT),
          :tax => attrs.delete(:TAXAMT)
        )

        # warn ignored params
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end
