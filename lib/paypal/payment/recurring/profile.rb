module Paypal
  module Recurring
    class Profile < Base
      attr_required :start_date
      attr_optional :name, :reference
      attr_accessor :schedule, :billing, :activation

      def initialize(attributes = {})
        @schedule = Schedule.new attributes[:schedule]
        @billing = Billing.new attributes[:billing]
        @activation = Activation.new attributes[:activation]
        super
      end

      def to_params
        params = [
          self.schedule,
          self.billing,
          self.activation
        ].inject({}) do |params, attribute|
          params.merge! attribute.to_params
        end
        params.merge!(
          :PROFILESTARTDATE => self.start_date,
          :SUBSCRIBERNAME => self.name,
          :PROFILEREFERENCE => self.reference
        )
        params..delete_if(&:blank?)
      end
    end
  end
end