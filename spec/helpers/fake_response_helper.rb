require 'fakeweb'

module FakeResponseHelper

  def fake_response(file_path, options = {})
    Paypal::NVP::Request::ENDPOINT.each do |env, endpoint|
      FakeWeb.register_uri(
        :post,
        endpoint,
        options.merge(
          :body => File.read(File.join(File.dirname(__FILE__), '../fake_response', "#{file_path}.txt"))
        )
      )
    end
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