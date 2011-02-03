module Paypal
  module Payment
    class Request < Base
      attr_optional :amount, :action, :currency_code, :billing_type, :billing_agreement_description

      def to_params(index = 0)
        {
          :"PAYMENTREQUEST_#{index}_PAYMENTACTION" => self.action,
          :"PAYMENTREQUEST_#{index}_AMT" => Util.formatted_amount(self.amount),
          :"PAYMENTREQUEST_#{index}_CURRENCYCODE" => self.currency_code,
          :"L_BILLINGTYPE#{index}" => self.billing_type,
          :"L_BILLINGAGREEMENTDESCRIPTION#{index}" => self.billing_agreement_description
        }.delete_if do |k, v|
          v.blank?
        end
      end
    end
  end
end
