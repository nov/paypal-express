module Paypal
  module Payment
    class Request < Base
      attr_optional :amount, :tax_amount, :shipping_amount, :action, :currency_code, :description, :notify_url, :billing_type, :billing_agreement_description
      attr_accessor :items

      def initialize(attributes = {})
        @items = []
        Array(attributes[:items]).each do |item_attrs|
          @items << Item.new(item_attrs)
        end
        super
      end

      def to_params(index = 0)
        params = {
          :"PAYMENTREQUEST_#{index}_PAYMENTACTION" => self.action,
          :"PAYMENTREQUEST_#{index}_AMT" => Util.formatted_amount(self.amount),
          :"PAYMENTREQUEST_#{index}_TAXAMT" => Util.formatted_amount(self.tax_amount),
          :"PAYMENTREQUEST_#{index}_SHIPPINGAMT" => Util.formatted_amount(self.shipping_amount),
          :"PAYMENTREQUEST_#{index}_CURRENCYCODE" => self.currency_code,
          :"PAYMENTREQUEST_#{index}_DESC" => self.description,
          # NOTE:
          #  notify_url works only when DoExpressCheckoutPayment called.
          #  recurring payment doesn't support dynamic notify_url.
          :"PAYMENTREQUEST_#{index}_NOTIFYURL" => self.notify_url,
          :"L_BILLINGTYPE#{index}" => self.billing_type,
          :"L_BILLINGAGREEMENTDESCRIPTION#{index}" => self.billing_agreement_description,
        }.delete_if do |k, v|
          v.blank?
        end
        if self.items.present?
          params[:"PAYMENTREQUEST_#{index}_ITEMAMT"] = Util.formatted_amount(self.items_amount)
          self.items.each_with_index do |item, item_index|
            params.merge! item.to_params(index, item_index)
          end
        end
        params
      end

      def items_amount
        self.items.inject(0.0) do |total, item|
          total += item.quantity * item.amount.to_f
        end
      end
    end
  end
end
