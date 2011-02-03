require "logger"
require 'active_support/core_ext'
require 'attr_required'
require 'attr_optional'
require 'restclient_with_ssl_support'

module Paypal

  API_VERSION = '66.0'
  ENDPOINT = {
    :production => 'https://www.paypal.com/cgi-bin/webscr',
    :sandbox => 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  }

  def self.log(message, mode = :info)
    self.logger.send mode, message
  end
  def self.logger
    @@logger
  end
  def self.logger=(logger)
    @@logger = logger
  end
  @@logger = Logger.new(STDERR)
  @@logger.progname = "Paypal::Express"

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

require 'paypal/base'
require 'paypal/exceptions'
require 'paypal/util'
require 'paypal/nvp/request'
require 'paypal/nvp/response'
require 'paypal/express/request'
require 'paypal/express/response'
require 'paypal/payment/request'
require 'paypal/payment/response'
require 'paypal/payment/response/amount'
require 'paypal/payment/response/info'
require 'paypal/payment/response/payer'
require 'paypal/payment/response/recurring'
require 'paypal/payment/response/ship_to'
require 'paypal/payment/recurring'
require 'paypal/payment/recurring/activation'
require 'paypal/payment/recurring/billing'
require 'paypal/payment/recurring/summary'