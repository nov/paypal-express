module Paypal
  module Payment
    class Response::Payer
      attr_reader :identifier, :status, :first_name, :last_name, :email

      def initialize(attributes = {})
        @identifier = attributes[:identifier]
        @status = attributes[:status]
        @first_name = attributes[:first_name]
        @last_name = attributes[:last_name]
        @email = attributes[:email]
      end
    end
  end
end