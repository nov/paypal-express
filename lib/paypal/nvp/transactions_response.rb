module Paypal
  module NVP
    class TransactionsResponse < Base
      cattr_reader :attribute_mapping
      @@attribute_mapping = {
        :ACK => :ack,
        :CORRELATIONID => :correlation_id,
        :TIMESTAMP => :timestamp,
        :VERSION => :version,
        :CUSTOM => :custom,
        :ERRORCODE => :error_code,
        :SHORTMESSAGE => :short_message,
        :LONGMESSAGE => :long_message,
        :SEVERITYCODE => :severity_code,
        :BUILD => :build
      }
      attr_accessor *@@attribute_mapping.values
      attr_accessor :transactions

      def initialize(attributes = {})
        # payment_info
        attrs = attributes.dup

        @@attribute_mapping.each do |key, value|
          self.send "#{value}=", attrs.delete(key)
        end

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
