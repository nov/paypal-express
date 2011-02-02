require 'active_support/core_ext/object'
require 'attr_required'
require 'attr_optional'
require 'restclient_with_ssl_support'

require 'paypal/exceptions'
require 'paypal/nvp/request'
require 'paypal/nvp/response'
require 'paypal/express/request'
require 'paypal/express/response'
require 'paypal/payment/request'
require 'paypal/payment/response'

module Paypal

  API_VERSION = '66.0'
  ENDPOINT = {
    :production => 'https://www.paypal.com/cgi-bin/webscr',
    :sandbox => 'https://www.sandbox.paypal.com/cgi-bin/webscr'
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