require 'spec_helper.rb'

describe Paypal::Express::Request do
  class Paypal::Express::Request
    attr_accessor :_sent_params_, :_method_
    def post_with_logging(method, params)
      self._method_ = method
      self._sent_params_ = params
      post_without_logging method, params
    end
    alias_method_chain :post, :logging
  end

  let :attributes do
    {
      :username => 'nov',
      :password => 'password',
      :signature => 'sig',
      :return_url => 'http://example.com/success',
      :cancel_url => 'http://example.com/cancel'
    }
  end

  let :instance do
    Paypal::Express::Request.new attributes
  end

  let :instant_payment_request do
    Paypal::Payment::Request.new(
      :amount => 1000,
      :description => 'Instant Payment Request'
    )
  end

  let :recurring_payment_request do
    Paypal::Payment::Request.new( 
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  let :recurring_profile do
    Paypal::Payment::Recurring.new(
      :start_date => Time.utc(2011, 2, 8, 9, 0, 0),
      :description => 'Recurring Profile',
      :billing => {
        :period => :Month,
        :frequency => 1,
        :amount => 1000
      }
    )
  end

  describe '.new' do
    context 'when any required parameters are missing' do
      it 'should raise AttrMissing exception' do
        attributes.keys.each do |missing_key|
          insufficient_attributes = attributes.reject do |key, value|
            key == missing_key
          end
          lambda do
            Paypal::Express::Request.new insufficient_attributes
          end.should raise_error AttrRequired::AttrMissing
        end
      end
    end

    context 'when all required parameters are given' do
      it 'should succeed' do
        lambda do
          Paypal::Express::Request.new attributes
        end.should_not raise_error AttrRequired::AttrMissing
      end
    end
  end

  describe '#setup' do
    context 'when instance payment request given' do
      it 'should call SetExpressCheckout' do
        lambda do
          instance.setup instant_payment_request
        end.should request_to 'https://api-3t.paypal.com/nvp', :post
        instance._method_.should == :SetExpressCheckout
        instance._sent_params_.should == {
          :PAYMENTREQUEST_0_DESC => 'Instant Payment Request',
          :RETURNURL => 'http://example.com/success',
          :CANCELURL => 'http://example.com/cancel',
          :PAYMENTREQUEST_0_AMT => '1000.00'
        }
      end
    end

    context 'when recurring payment request given' do
      it 'should call SetExpressCheckout' do
        lambda do
          instance.setup recurring_payment_request
        end.should request_to 'https://api-3t.paypal.com/nvp', :post
        instance._method_.should == :SetExpressCheckout
        instance._sent_params_.should == {
          :L_BILLINGTYPE0 => :RecurringPayments,
          :L_BILLINGAGREEMENTDESCRIPTION0 => 'Recurring Payment Request',
          :RETURNURL => 'http://example.com/success',
          :CANCELURL => 'http://example.com/cancel',
          :PAYMENTREQUEST_0_AMT => '0.00'
        }
      end
    end

    context 'when got success response' do
      before do
        fake_response 'SetExpressCheckout/success'
      end

      it 'should return Paypal::Express::Response' do
        response = instance.setup recurring_payment_request
        response.should be_instance_of(Paypal::Express::Response)
      end
    end

    context 'when got error response' do
      before do
        fake_response 'SetExpressCheckout/failure'
      end

      it 'should raise Paypal::APIError' do
        lambda do
          instance.setup recurring_payment_request
        end.should raise_error(Paypal::APIError)
      end
    end
  end

  describe '#details' do
    it 'should call GetExpressCheckoutDetails' do
      lambda do
        instance.details 'token'
      end.should request_to 'https://api-3t.paypal.com/nvp', :post
      instance._method_.should == :GetExpressCheckoutDetails
      instance._sent_params_.should == {
        :TOKEN => 'token'
      }
    end
  end

  describe '#checkout!' do
    it 'should call DoExpressCheckoutPayment' do
      lambda do
        instance.checkout! 'token', 'payer_id', instant_payment_request
      end.should request_to 'https://api-3t.paypal.com/nvp', :post
      instance._method_.should == :DoExpressCheckoutPayment
      instance._sent_params_.should == {
        :PAYERID => 'payer_id',
        :TOKEN => 'token',
        :PAYMENTREQUEST_0_DESC => 'Instant Payment Request',
        :PAYMENTREQUEST_0_AMT => '1000.00'
      }
    end
  end

  describe '#subscribe!' do
    it 'should call CreateRecurringPaymentsProfile' do
      lambda do
        instance.subscribe! 'token', recurring_profile
      end.should request_to 'https://api-3t.paypal.com/nvp', :post
      instance._method_.should == :CreateRecurringPaymentsProfile
      instance._sent_params_.should == {
        :AMT => '1000.00',
        :MAXFAILEDPAYMENTS => 0,
        :BILLINGPERIOD => :Month,
        :PROFILESTARTDATE => '2011-02-08 09:00:00',
        :DESC => 'Recurring Profile',
        :TRIALAMT => '0.00',
        :TRIALTOTALBILLINGCYCLES => 0,
        :TRIALBILLINGFREQUENCY => 0,
        :TOKEN => 'token',
        :TAXAMT => '0.00',
        :TOTALBILLINGCYCLES => 0,
        :INITAMT => '0.00',
        :SHIPPINGAMT => '0.00',
        :BILLINGFREQUENCY => 1
      }
    end
  end

  describe '#subscription' do
    it 'should call GetRecurringPaymentsProfileDetails' do
      lambda do
        instance.subscription 'profile_id'
      end.should request_to 'https://api-3t.paypal.com/nvp', :post
      instance._method_.should == :GetRecurringPaymentsProfileDetails
      instance._sent_params_.should == {
        :PROFILEID => 'profile_id'
      }
    end
  end

  describe '#renew!' do
    it 'should call ManageRecurringPaymentsProfileStatus' do
      lambda do
        instance.renew! 'profile_id', :Cancel
      end.should request_to 'https://api-3t.paypal.com/nvp', :post
      instance._method_.should == :ManageRecurringPaymentsProfileStatus
      instance._sent_params_.should == {
        :ACTION => :Cancel,
        :PROFILEID => 'profile_id',
        :NOTE => ''
      }
    end
  end

end