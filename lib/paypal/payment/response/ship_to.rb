module Paypal
  module Payment
    class Response::ShipTo < Base
      attr_optional :owner, :status, :name, :zip, :street, :street2, :city, :state, :country_code, :country_name
    end
  end
end