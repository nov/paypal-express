require 'spec_helper.rb'

describe Paypal::Express::Response do
  let :request do
    Paypal::Express::Request.new(
      :username => 'nov',
      :password => 'password',
      :signature => 'sig',
      :return_url => 'http://example.com/success',
      :cancel_url => 'http://example.com/cancel'
    )
  end

  let :payment_request do
    Paypal::Payment::Request.new( 
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  let :instance do
    request.setup payment_request
  end

  describe '#initialize' do
    before do
      fake_response 'SetExpressCheckout/success'
    end

    it 'should support on_mobile option' do
      response = request.setup payment_request, :on_mobile => true
      response.on_mobile.should be_true
      response.send(:query)[:cmd].should == '_express-checkout-mobile'
    end

    it 'should support pay_on_paypal option' do
      response = request.setup payment_request, :pay_on_paypal => true
      response.pay_on_paypal.should be_true
      response.send(:query)[:useraction].should == 'commit'
    end
  end

  describe '#redirect_uri' do
    it 'should return express-checkout redirect endpoint with token' do
      fake_response 'SetExpressCheckout/success'
      instance.redirect_uri.should == 'https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-5YJ90598G69065317'
    end

    it 'should support sandbox mode' do
      sandbox_mode do
        fake_response 'SetExpressCheckout/success'
        instance.redirect_uri.should == 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&token=EC-5YJ90598G69065317'
      end
    end
  end

  describe '#popup_url' do
    it 'should return express-checkout popup endpoint with token' do
      fake_response 'SetExpressCheckout/success'
      instance.popup_url.should == 'https://www.paypal.com/incontext?token=EC-5YJ90598G69065317'
    end

    it 'should support sandbox mode' do
      sandbox_mode do
        fake_response 'SetExpressCheckout/success'
        instance.popup_url.should == 'https://www.sandbox.paypal.com/incontext?token=EC-5YJ90598G69065317'
      end
    end
  end

end