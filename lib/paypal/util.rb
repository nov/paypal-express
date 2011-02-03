module Paypal
  module Util

    def self.formatted_amount(amount)
      if amount.to_f == amount.to_i
        "#{amount.to_i}.00"
      else
        "#{amount.to_i}.#{(amount * 100).to_s.split(".").first[-2,2]}"
      end
    end

    def self.numeric_amount(amount)
      if amount.to_f == amount.to_i
        amount.to_i
      else
        amount.to_f
      end
    end

    def numeric_attributes?(key)
      key.to_s =~ /(amount|frequency|cycles|paid)/
    end

  end
end