require 'restclient'

module RestClient

  def self.ssl_settings
    {
      :verify_ssl => OpenSSL::SSL::VERIFY_PEER,
      :ssl_ca_file => File.join(File.dirname(__FILE__), 'cert')
    }
  end

  def self.post(url, payload, headers={}, &block)
    Request.execute(ssl_settings.merge(:method => :post, :url => url, :payload => payload, :headers => headers), &block)
  end

end