module Paypal
  module Payment
    class Response::Reference < Base
      attr_required :identifier
      attr_optional :description, :status
      attr_accessor :info
    end
  end
end