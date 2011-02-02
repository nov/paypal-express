require 'attr_required'
require 'attr_optional'
require 'restclient_with_ssl_support'

require 'paypal/exceptions'
require 'paypal/nvp'
require 'paypal/nvp/response'
require 'paypal/express'
require 'paypal/payment_request'

module Paypal
  API_VERSION = '66.0'
end