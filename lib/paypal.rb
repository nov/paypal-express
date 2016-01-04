require 'logger'
require 'active_support'
require 'active_support/core_ext'
require 'attr_required'
require 'attr_optional'
require 'rest_client'

module Paypal
  mattr_accessor :api_version
  self.api_version = '88.0'

  ENDPOINT = {
    :production => 'https://www.paypal.com/cgi-bin/webscr',
    :sandbox => 'https://www.sandbox.paypal.com/cgi-bin/webscr'
  }
  POPUP_ENDPOINT = {
    :production => 'https://www.paypal.com/incontext',
    :sandbox => 'https://www.sandbox.paypal.com/incontext'
  }

  def self.endpoint
    if sandbox?
      Paypal::ENDPOINT[:sandbox]
    else
      Paypal::ENDPOINT[:production]
    end
  end
  def self.popup_endpoint
    if sandbox?
      Paypal::POPUP_ENDPOINT[:sandbox]
    else
      Paypal::POPUP_ENDPOINT[:production]
    end
  end

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
  @@logger.progname = 'Paypal::Express'

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

require 'paypal/util'
require 'paypal/exception'
require 'paypal/exception/http_error'
require 'paypal/exception/api_error'
require 'paypal/base'
require 'paypal/ipn'
require 'paypal/nvp/request'
require 'paypal/nvp/response'
require 'paypal/nvp/transactions_response'
require 'paypal/payment/common/amount'
require 'paypal/express/request'
require 'paypal/express/response'
require 'paypal/express/transactions_response'
require 'paypal/payment/request'
require 'paypal/payment/request/item'
require 'paypal/payment/response'
require 'paypal/payment/response/info'
require 'paypal/payment/response/item'
require 'paypal/payment/response/payer'
require 'paypal/payment/response/reference'
require 'paypal/payment/response/refund'
require 'paypal/payment/response/address'
require 'paypal/payment/response/transaction'
require 'paypal/payment/recurring'
require 'paypal/payment/recurring/activation'
require 'paypal/payment/recurring/billing'
require 'paypal/payment/recurring/summary'
