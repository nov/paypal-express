module Paypal
  module Payment
    class Recurring < Base
      attr_optional :start_date, :description, :identifier, :status, :name, :reference, :max_fails, :auto_bill, :aggregate_amount, :aggregate_optional_amount, :final_payment_date
      attr_accessor :activation, :billing, :regular_billing, :summary

      MANDATORY_PARAMETERS = [:DESC, :PROFILESTARTDATE, :BILLINGPERIOD, :BILLINGFREQUENCY, :AMT, :CURRENCYCODE].freeze

      def initialize(attributes = {})
        super
        @activation = Activation.new(attributes[:activation]) if attributes[:activation]
        @billing = Billing.new(attributes[:billing]) if attributes[:billing]
        @regular_billing = Billing.new(attributes[:regular_billing]) if attributes[:regular_billing]
        @summary = Summary.new(attributes[:summary]) if attributes[:summary]
        @raw_parameters = attributes[:raw].presence || {}
        @parameters = build_parameters_hash

        # can not make this happen as profile object is used both in cretion, response verification and status checks, which vary in available parameters
        # makes sure key params have been passed one way or the other
        # missing_mandatory_parameters = MANDATORY_PARAMETERS.map{|param| @parameters[param].present? ? nil : param}.compact
        # raise ArgumentError.new("Missing mandatory parameters #{missing_mandatory_parameters.to_s}") if missing_mandatory_parameters.any?
      end

      def to_params
        return @parameters
      end

      def numeric_attribute?(key)
        super || [:max_fails, :failed_count].include?(key)
      end

      protected
        def build_parameters_hash
          params = [
            self.billing,
            self.activation
          ].compact.inject({}) do |params, attribute|
            params.merge! attribute.to_params
          end

          params.merge!(
            :DESC  => self.description,
            :MAXFAILEDPAYMENTS => self.max_fails,
            :AUTOBILLOUTAMT => self.auto_bill,
            :PROFILESTARTDATE => (start_date.is_a?(Time) ? start_date.to_s(:db) : start_date),
            :SUBSCRIBERNAME => self.name,
            :PROFILEREFERENCE => self.reference
          )

          # allows passing raw keys overriding named assignment methods
          params.merge!(@raw_parameters)

          return params.delete_if do |k, v|
            v.blank?
          end
        end
    end
  end
end
