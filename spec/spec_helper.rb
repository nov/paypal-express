$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'paypal'
require 'rspec'
require 'helpers/fake_response_helper'

RSpec.configure do |config|
  config.before do
    Paypal.logger = double("logger")
  end
end

def sandbox_mode(&block)
  Paypal.sandbox!
  yield
ensure
  Paypal.sandbox = false
end