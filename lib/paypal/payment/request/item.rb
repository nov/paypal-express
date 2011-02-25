module Paypal
  module Payment
    class Request::Item < Base
      attr_optional :name, :description, :amount, :quantity, :category

      def initialize(attributes = {})
        super
        @quantity ||= 1
      end

      def to_params(parent_index, index = 0)
        {
          :"L_PAYMENTREQUEST_#{parent_index}_NAME#{index}" => self.name,
          :"L_PAYMENTREQUEST_#{parent_index}_DESC#{index}" => self.description,
          :"L_PAYMENTREQUEST_#{parent_index}_AMT#{index}" => Util.formatted_amount(self.amount),
          :"L_PAYMENTREQUEST_#{parent_index}_QTY#{index}" => self.quantity,
          :"L_PAYMENTREQUEST_#{parent_index}_ITEMCATEGORY#{index}" => self.category
        }.delete_if do |k, v|
          v.blank?
        end
      end
    end
  end
end
