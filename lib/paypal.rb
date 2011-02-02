require 'attr_required'
require 'attr_optional'
require 'restclient_with_ssl_support'

require 'paypal/exceptions'
require 'paypal/nvp'
require 'paypal/nvp/response'
require 'paypal/express'
require 'paypal/express/response'
require 'paypal/payment_request'

module Paypal

  API_VERSION = '66.0'
  ENDPOINT = {
    :production => 'http://www.paypal.com/cgi-bin/webscr',
    :sandbox => 'http://www.sandbox.paypal.com/cgi-bin/webscr'
  }

  def self.sandbox?
    @@sandbox
  end
  def self.sandbox!
    self.sandbox = true
  end
  def self.sandbox=(boolean)
    @@sandbox = boolean
  end
  self.sandbox = false

end