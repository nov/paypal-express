require 'fakeweb'

module FakeResponseHelper

  def fake_response(method, params, file_path, options = {})
    FakeWeb.register_uri(
      :post,
      Paypal::NVP::ENDPOINT[:production],
      options.merge(
        :body => File.read(File.join(File.dirname(__FILE__), '../fake_reponse', "#{file_path}.txt"))
      )
    )
  end

end

FakeWeb.allow_net_connect = false
include FakeResponseHelper