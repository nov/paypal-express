module Paypal
  module NVP
    class Response
      attr_accessor :ack, :correlation_id, :timestamp, :build, :version, :token
    
      {:SHIPTOZIP=>"150-0002", :PAYERSTATUS=>"verified", :SHIPTOCOUNTRYCODE=>"JP", :CHECKOUTSTATUS=>"PaymentActionNotInitiated", :LASTNAME=>"User", :AMT=>"12.00", :SHIPPINGAMT=>"0.00", :TAXAMT=>"0.00", :SHIPTOSTATE=>"Tokyo", :ADDRESSSTATUS=>"Unconfirmed", :PAYERID=>"SDFHZQS6KTZGG", :SHIPDISCAMT=>"0.00", :EMAIL=>"buyer_1289794459_per@matake.jp", :SHIPTOCITY=>"Shibuya-ku", :INSURANCEAMT=>"0.00", :SHIPTOSTREET=>"Nishi 4-chome, Kita 55-jo, Kita-ku", :SHIPTOCOUNTRYNAME=>"Japan", :FIRSTNAME=>"Test", :COUNTRYCODE=>"JP", :CURRENCYCODE=>"USD", :SHIPTONAME=>"Test User", :HANDLINGAMT=>"0.00"}
    
      alias_method :status, :ack

      def initialize(response_params = {})
        @ack = response_params[:ACK]
        @correlation_id = response_params[:CORRELATIONID]
        @timestamp = response_params[:TIMESTAMP]
        @build = response_params[:BUILD]
        @version = response_params[:VERSION]
        @token = response_params[:TOKEN]
      end
    end
  end
end