module Paypal
  module Payment
    class Recurring < Base
      attr_required :start_date, :description
      attr_optional :identifier, :status, :name, :reference, :max_fails, :auto_bill
      attr_accessor :billing, :activation

      def initialize(attributes = {})
        @billing = Billing.new attributes[:billing] if attributes[:billing].present?
        @activation = Activation.new attributes[:activation] if attributes[:activation].present?
        super
        if @start_date.is_a?(Time)
          @start_date = @start_date.to_s(:db)
        end
      end

      def to_params
        params = [
          self.schedule,
          self.billing,
          self.activation
        ].inject({}) do |params, attribute|
          params.merge! attribute.to_params if attribute.present?
        end
        params.merge!(
          :DESC  => self.description,
          :MAXFAILEDPAYMENTS => self.max_fails,
          :AUTOBILLAMT => self.auto_bill
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