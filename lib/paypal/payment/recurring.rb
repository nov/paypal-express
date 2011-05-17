module Paypal
  module Payment
    class Recurring < Base
      attr_optional :start_date, :description, :identifier, :status, :name, :reference, :max_fails, :auto_bill, :aggregate_amount, :aggregate_optional_amount, :final_payment_date
      attr_accessor :activation, :billing, :regular_billing, :summary

      def initialize(attributes = {})
        super
        @activation = Activation.new attributes[:activation] if attributes[:activation]
        @billing = Billing.new attributes[:billing] if attributes[:billing]
        @regular_billing = Billing.new attributes[:regular_billing] if attributes[:regular_billing]
        @summary = Summary.new attributes[:summary] if attributes[:summary]
      end

      def to_params
        params = [
          self.billing,
          self.activation
        ].compact.inject({}) do |params, attribute|
          params.merge! attribute.to_params
        end
        if self.start_date.is_a?(Time)
          self.start_date = self.start_date.to_s(:db)
        end
        params.merge!(
          :DESC  => self.description,
          :MAXFAILEDPAYMENTS => self.max_fails,
          :AUTOBILLOUTAMT => self.auto_bill,
          :PROFILESTARTDATE => self.start_date,
          :SUBSCRIBERNAME => self.name,
          :PROFILEREFERENCE => self.reference
        )
        params.delete_if do |k, v|
          v.blank?
        end
      end

      def numeric_attribute?(key)
        super || [:max_fails, :failed_count].include?(key)
      end
    end
  end
end