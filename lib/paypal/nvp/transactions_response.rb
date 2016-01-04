module Paypal
  module NVP
    class TransactionsResponse < Base
      attr_accessor :transactions

      def initialize(attributes = {})
        # payment_info
        attrs = attributes.dup

        transactions = []
        attrs.keys.each do |_attr_|
          key, index = _attr_.to_s.scan(/^L_(.+?)(\d+)$/).flatten
          if index
            transactions[index.to_i] ||= {}
            transactions[index.to_i][key.to_sym] = attrs.delete(_attr_)
          end
        end
        @transactions = transactions.collect do |_attrs_|
          Payment::Response::Transaction.new _attrs_
        end

        # warn ignored attrs
        attrs.each do |key, value|
          Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
        end
      end
    end
  end
end
