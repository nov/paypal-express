module Paypal
  module Payment
    class Response::ShipTo < Base
      attr_optional :name, :zip, :street, :city, :state, :country_code, :country_name
    end
  end
end