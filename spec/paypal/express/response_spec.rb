require 'spec_helper.rb'

describe Paypal::Express::Response do
  before do
    fake_response 'SetExpressCheckout/success'
  end

  let :instance do
    request = Paypal::Express::Request.new(
      :username => 'nov',
      :password => 'password',
      :signature => 'sig',
      :return_url => 'http://example.com/success',
      :cancel_url => 'http://example.com/cancel'
    )
    request.setup Paypal::Payment::Request.new( 
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  describe '#redirect_uri' do
    it 'should return express-checkout redirect endpoint with token' do
      instance.redirect_uri.should == 'https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-5YJ90598G69065317'
    end

    it 'should support sandbox mode' do
      sandbox_mode do
        instance.redirect_uri.should == 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-5YJ90598G69065317'
      end
    end
  end
end