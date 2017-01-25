require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require 'paypal'
require 'rspec'
require 'pry'
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

def expected_recurring_profile_parameters(options={})

    # optional initial payment parameters
    # :INITAMT => "9.00",
    # :FAILEDINITAMTACTION => "CancelOnFailure", # or "ContinueOnFailure"
    #
    # # optional trial parameters
    # :TRIALBILLINGPERIOD => "Day",
    # :TRIALBILLINGFREQUENCY => "7",
    # :TRIALAMT => "0.00",
    # :TRIALCURRENCYCODE => "EUR",
    # :TRIALTOTALBILLINGCYCLES => "1",
    #
    # # mandatory regular recurring profile parameters
    # :DESC => "Funny Movie Clips Subscription",
    # :PROFILESTARTDATE => "2017-01-25T15:00:00Z",
    # :BILLINGPERIOD => "Day", # "Month", "Year"
    # :BILLINGFREQUENCY => "30",
    # :AMT => "9.00", # two-decimals for cents, whole number for whole currency, like a Euro or Dollar
    # :CURRENCYCODE => "EUR",
    #
    # # termination
    # :TOTALBILLINGCYCLES => "0", # optional field, '0' value makes profile last forever
    # :MAXFAILEDPAYMENTS => "3",
    # :AUTOBILLAMT => "AddToNextBilling",
    #
    # # Digital goods fields
    # :L_PAYMENTREQUEST_0_ITEMCATEGORY0 => "Digital",
    # :L_PAYMENTREQUEST_0_NAME0 => "Cat Clip Collection",
    # :L_PAYMENTREQUEST_0_AMT0 => "9.00",
    # :L_PAYMENTREQUEST_0_QTY0 => "1",
  return mandatory_profile_parameters.merge(trial_profile_parameters).merge(initial_payment_profile_parameters).merge(auxilary_profile_parameters).merge(options)
end

def mandatory_profile_parameters(options={})
  return {
    :DESC => "Funny Movie Clips Subscription",
    :PROFILESTARTDATE => "2017-01-25T15:00:00Z",
    :BILLINGPERIOD => "Day", # "Month", "Year"
    :BILLINGFREQUENCY => "30",
    :AMT => "9.00", # two-decimals for cents, whole number for whole currency, like a Euro or Dollar
    :CURRENCYCODE => "EUR",
  }.merge(options)
end

def trial_profile_parameters(options={})
  return {
    # optional trial parameters
    :TRIALBILLINGPERIOD => "Day",
    :TRIALBILLINGFREQUENCY => "7",
    :TRIALAMT => "0.00",
    :TRIALCURRENCYCODE => "EUR",
    :TRIALTOTALBILLINGCYCLES => "1",
  }.merge(options)
end

def initial_payment_profile_parameters(options={})
  return {
    # optional initial payment parameters
    :INITAMT => "9.00",
    :FAILEDINITAMTACTION => "CancelOnFailure", # or "ContinueOnFailure"
  }.merge(options)
end

def auxilary_profile_parameters(options={})
  return {
    :TOTALBILLINGCYCLES => "0", # optional field, '0' value makes profile last forever
    :MAXFAILEDPAYMENTS => "3",
    :AUTOBILLAMT => "AddToNextBilling",

    :L_PAYMENTREQUEST_0_ITEMCATEGORY0 => "Digital",
    :L_PAYMENTREQUEST_0_NAME0 => "Cat Clip Collection",
    :L_PAYMENTREQUEST_0_AMT0 => "9.00",
    :L_PAYMENTREQUEST_0_QTY0 => "1",
  }.merge(options)
end
