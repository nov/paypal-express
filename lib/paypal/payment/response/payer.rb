module Paypal
  module Payment
    class Response::Payer < Base
      attr_optional :identifier, :status, :first_name, :last_name, :email, :phone
    end
  end
end
