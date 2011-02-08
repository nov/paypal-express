require 'spec_helper.rb'

describe Paypal::Payment::Request do
  let :instant_request do
    Paypal::Payment::Request.new(
      :amount => 10,
      :currency_code => :JPY,
      :description => 'Instant Payment Request',
      :notify_url => 'http://marchant.example.com/notify'
    )
  end
  let :recurring_request do
    Paypal::Payment::Request.new(
      :currency_code => :JPY,
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  it 'should handle Instant Payment parameters' do
    instant_request.amount.should == 10
    instant_request.currency_code.should == :JPY
    instant_request.description.should == 'Instant Payment Request'
    instant_request.notify_url.should == 'http://marchant.example.com/notify'
    instant_request.to_params.should == {
      :PAYMENTREQUEST_0_AMT => "10.00",
      :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
      :PAYMENTREQUEST_0_DESC => "Instant Payment Request", 
      :PAYMENTREQUEST_0_NOTIFYURL => "http://marchant.example.com/notify"
    }
  end

  it 'should handle Recurring Payment parameters' do
    recurring_request.currency_code.should == :JPY
    recurring_request.billing_type.should == :RecurringPayments
    recurring_request.billing_agreement_description.should == 'Recurring Payment Request'
    recurring_request.to_params.should == {
      :PAYMENTREQUEST_0_AMT => "0.00",
      :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
      :L_BILLINGTYPE0 => :RecurringPayments,
      :L_BILLINGAGREEMENTDESCRIPTION0 => "Recurring Payment Request"
    }
  end
end