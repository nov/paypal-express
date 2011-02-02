module Paypal
  module NVP
    class Response
      attribute_mapping = {
        :ACK => :ack,
        :ADDRESSSTATUS => :address_status,
        :BUILD => :build,
        :CHECKOUTSTATUS => :checkout_status,
        :CORRELATIONID => :colleration_id,
        :COUNTRYCODE => :country_code,
        :CURRENCYCODE => :currency_code,
        :TIMESTAMP => :timestamp,
        :TOKEN => :token,
        :VERSION => :version
      }
      attr_accessor *attribute_mapping.values
      attr_accessor :amount, :payer, :ship_to, :payment_responses

      def initialize(response_params = {})
        attribute_mapping.each do |key, value|
          self.send "#{value}=", response_params[key]
        end
        @amount = Payment::Response::Amount.new(
          :total => response_params[:AMT],
          :handing => response_params[:HANDLINGAMT],
          :insurance => response_params[:INSURANCEAMT],
          :ship_disc => response_params[:SHIPDISCAMT],
          :shipping => response_params[:SHIPPINGAMT],
          :tax => response_params[:TAXAMT]
        )
        @payer = Payment::Response::Payer.new(
          :identifier => response_params[:PAYERID],
          :status => response_params[:PAYERSTATUS],
          :first_name => response_params[:FIRSTNAME],
          :last_name => response_params[:LASTNAME],
          :email => response_params[:EMAIL]
        )
        @ship_to = Payment::Response::ShipTo.new(
          :name => response_params[:SHIPTONAME],
          :zip => response_params[:SHIPTOZIP],
          :street => response_params[:SHIPTOSTREET],
          :city => response_params[:SHIPTOCITY],
          :state => response_params[:SHIPTOSTATE],
          :country_code => response_params[:SHIPTOCOUNTRYCODE],
          :country_name => response_params[:SHIPTOCOUNTRYNAME]
        )
        @payment_responses = []
      end
    end
  end
end