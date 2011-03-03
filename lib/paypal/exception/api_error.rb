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
        super 'PayPal API Error'
      end

      class Response
        cattr_reader :attribute_mapping
        @@attribute_mapping = {
          :ACK => :ack,
          :BUILD => :build,
          :CORRELATIONID => :colleration_id,
          :TIMESTAMP => :timestamp,
          :VERSION => :version
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
      end
    end
  end
end