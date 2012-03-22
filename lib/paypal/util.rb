module Paypal
  module Util

    def self.formatted_amount(x)
      # Thanks @nahi ;)
      sprintf "%0.2f", BigDecimal.new(x.to_s).round(2)
    end

    def self.to_numeric(x)
      if x.to_f == x.to_i
        x.to_i
      else
        x.to_f
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