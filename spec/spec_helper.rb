require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require 'paypal'
require 'rspec'
require 'helpers/fake_response_helper'

RSpec.configure do |config|
  config.before do
    Paypal.logger = double("logger")
  end
  config.after do
    FakeWeb.clean_registry
  end
end

def sandbox_mode(&block)
  Paypal.sandbox!
  yield
ensure
  Paypal.sandbox = false
end