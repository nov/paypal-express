require "bigdecimal"

module Paypal
  module Util

    def self.formatted_amount(x)
      # Thanks @nahi ;)
      sprintf "%0.2f", BigDecimal.new(x.to_s).truncate(2)
    end

    def self.to_numeric(x)
      decimal = BigDecimal(x.to_s)

      if decimal == x.to_i
        x.to_i
      else
        decimal
      end
    end

    def numeric_attribute?(key)
      !!(key.to_s =~ /(amount|frequency|cycles|paid)/)
    end

    def ==(other)
      instance_variables.all? do |key|
        instance_variable_get(key) == other.instance_variable_get(key)
      end
    end

  end
end
