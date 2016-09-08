require 'fakeweb'

module FakeResponseHelper

  def fake_response(file_path, api = :NVP, options = {})
    endpoint = case api
    when :NVP
      Paypal::NVP::Request.endpoint(options[:environment])
    when :IPN
      Paypal::IPN.endpoint(options[:environment])
    else
      raise "Non-supported API: #{api}"
    end
    FakeWeb.register_uri(
      :post,
      endpoint,
      options.merge(
        :body => File.read(File.join(File.dirname(__FILE__), '../fake_response', "#{file_path}.txt"))
      )
    )
  end

  def request_to(endpoint, method = :get)
    raise_error(
      FakeWeb::NetConnectNotAllowedError,
      "Real HTTP connections are disabled. Unregistered request: #{method.to_s.upcase} #{endpoint}"
    )
  end

end

FakeWeb.allow_net_connect = false
include FakeResponseHelper
