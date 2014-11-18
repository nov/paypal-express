module Paypal
  class Exception
    class APIError < Exception
      attr_accessor :response
      def initialize(response = {})
        @response = if response.is_a?(Hash)
          Response.new response
        else
          response
        end
      end

      def message
        if response.respond_to?(:short_messages) && response.short_messages.any?
          "PayPal API Error: " <<
            response.short_messages.map{ |m| "'#{m}'" }.join(", ")
        else
          "PayPal API Error"
        end
      end

      class Response
        cattr_reader :attribute_mapping
        @@attribute_mapping = {
          :ACK => :ack,
          :BUILD => :build,
          :CORRELATIONID => :correlation_id,
          :TIMESTAMP => :timestamp,
          :VERSION => :version,
          :ORDERTIME => :order_time,
          :PENDINGREASON => :pending_reason,
          :PAYMENTSTATUS => :payment_status,
          :PAYMENTTYPE => :payment_type,
          :REASONCODE => :reason_code,
          :TRANSACTIONTYPE => :transaction_type
        }
        attr_accessor *@@attribute_mapping.values
        attr_accessor :raw, :details

        class Detail
          cattr_reader :attribute_mapping
          @@attribute_mapping = {
            :ERRORCODE => :error_code,
            :SEVERITYCODE => :severity_code,
            :LONGMESSAGE => :long_message,
            :SHORTMESSAGE => :short_message
          }
          attr_accessor *@@attribute_mapping.values

          def initialize(attributes = {})
            @raw = attributes
            attrs = attributes.dup
            @@attribute_mapping.each do |key, value|
              self.send "#{value}=", attrs.delete(key)
            end

            # warn ignored params
            attrs.each do |key, value|
              Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
            end
          end
        end

        def initialize(attributes = {})
          attrs = attributes.dup
          @raw = attributes
          @@attribute_mapping.each do |key, value|
            self.send "#{value}=", attrs.delete(key)
          end
          details = []
          attrs.keys.each do |attribute|
            key, index = attribute.to_s.scan(/^L_(\S+)(\d+)$/).first
            next if [key, index].any?(&:blank?)
            details[index.to_i] ||= {}
            details[index.to_i][key.to_sym] = attrs.delete(attribute)
          end
          @details = details.collect do |_attrs_|
            Detail.new _attrs_
          end

          # warn ignored params
          attrs.each do |key, value|
            Paypal.log "Ignored Parameter (#{self.class}): #{key}=#{value}", :warn
          end
        end

        def short_messages
          details.map(&:short_message).compact
        end
      end
    end
  end
end
