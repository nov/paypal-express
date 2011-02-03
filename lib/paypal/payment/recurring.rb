module Paypal
  module Payment
    class Recurring < Base
      attr_required :start_date, :description
      attr_optional :identifier, :status, :name, :reference, :max_fails, :auto_bill, :aggregate_amount, :aggregate_optional_amount, :final_payment_date
      attr_accessor :activation, :billing, :regular_billing, :summary

      def initialize(attributes = {})
        super
        {
          :activation => Activation,
          :billing => Billing,
          :regular_billing => Billing,
          :summary => Summary
        }.each do |key, klass|
          if attributes[key].present?
            self.send "#{key}=", klass.new(attributes[key])
          end
        end
        if @start_date.is_a?(Time)
          @start_date = @start_date.to_s(:db)
        end
      end

      def to_params
        params = [
          self.billing,
          self.activation
        ].compact.inject({}) do |params, attribute|
          params.merge! attribute.to_params
        end
        params.merge!(
          :DESC  => self.description,
          :MAXFAILEDPAYMENTS => self.max_fails,
          :AUTOBILLAMT => self.auto_bill,
          :PROFILESTARTDATE => self.start_date,
          :SUBSCRIBERNAME => self.name,
          :PROFILEREFERENCE => self.reference
        )
        params.delete_if do |k, v|
          v.blank?
        end
      end
    end
  end
end