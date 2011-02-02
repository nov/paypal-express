$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'paypal'
require 'rspec'
require 'helpers/fake_response_helper'

def sandbox_mode(&block)
  Paypal.sandbox!
  yield
ensure
  Paypal.sandbox = false
end