module Paypal
  class NVP::Response
    attr_accessor :ack, :correlation_id, :timestamp, :build, :version, :token
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