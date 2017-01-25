# rspec spec/paypal/nvp/response_spec.rb
describe Paypal::NVP::Response do
  let(:return_url) { 'http://example.com/success' }
  let(:cancel_url) { 'http://example.com/cancel' }
  let :request do
    Paypal::Express::Request.new(
      :username => 'nov',
      :password => 'password',
      :signature => 'sig'
    )
  end

  let :payment_request do
    Paypal::Payment::Request.new(
      :amount => 1000,
      :description => 'Instant Payment Request'
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
    context 'when non-supported attributes are given' do
      it 'should ignore them and warn' do
        Paypal.logger.should_receive(:warn).with(
          "Ignored Parameter (Paypal::NVP::Response): ignored=Ignore me!"
        )
        Paypal::NVP::Response.new(
          :ignored => 'Ignore me!'
        )
      end
    end

    context 'when SetExpressCheckout response given' do
      before do
        fake_response 'SetExpressCheckout/success'
      end

      it 'should handle all attributes' do
        Paypal.logger.should_not_receive(:warn)
        response = request.setup payment_request, return_url, cancel_url
        response.token.should == 'EC-5YJ90598G69065317'
      end
    end

    context 'when GetExpressCheckoutDetails response given' do
      before do
        fake_response 'GetExpressCheckoutDetails/success'
      end

      it 'should handle all attributes' do
        Paypal.logger.should_not_receive(:warn)
        response = request.details 'token'
        response.payer.identifier.should == '9RWDTMRKKHQ8S'
        response.payment_responses.size.should == 1
        response.payment_info.size.should == 0
        response.payment_responses.first.should be_instance_of(Paypal::Payment::Response)
      end

      context 'when BILLINGAGREEMENTACCEPTEDSTATUS included' do
        before do
          fake_response 'GetExpressCheckoutDetails/with_billing_accepted_status'
        end

        it 'should handle all attributes' do
          Paypal.logger.should_not_receive(:warn)
          response = request.details 'token'
        end
      end
    end

    context 'when DoExpressCheckoutPayment response given' do
      before do
        fake_response 'DoExpressCheckoutPayment/success'
      end

      it 'should handle all attributes' do
        Paypal.logger.should_not_receive(:warn)
        response = request.checkout! 'token', 'payer_id', payment_request
        response.payment_responses.size.should == 0
        response.payment_info.size.should == 1
        response.payment_info.first.should be_instance_of(Paypal::Payment::Response::Info)
      end

      context 'when billing_agreement is included' do
        before do
          fake_response 'DoExpressCheckoutPayment/success_with_billing_agreement'
        end

        it 'should have billing_agreement' do
          Paypal.logger.should_not_receive(:warn)
          response = request.checkout! 'token', 'payer_id', payment_request
          response.billing_agreement.identifier.should == 'B-1XR87946TC504770W'
        end
      end
    end

    context 'when CreateRecurringPaymentsProfile response given' do
      before do
        fake_response 'CreateRecurringPaymentsProfile/success'
      end

      it 'should handle all attributes' do
        Paypal.logger.should_not_receive(:warn)
        response = request.subscribe! 'token', recurring_profile
        response.recurring.identifier.should == 'I-L8N58XFUCET3'
      end
    end

    context 'when GetRecurringPaymentsProfileDetails response given' do
      before do
        fake_response 'GetRecurringPaymentsProfileDetails/success'
      end

      it 'should handle all attributes' do
        Paypal.logger.should_not_receive(:warn)
        response = request.subscription 'profile_id'
        response.recurring.billing.amount.total.should == 1000
        response.recurring.regular_billing.paid.should == 1000
        response.recurring.summary.next_billing_date.should == '2011-03-04T10:00:00Z'
      end
    end

    context 'when ManageRecurringPaymentsProfileStatus response given' do
      before do
        fake_response 'ManageRecurringPaymentsProfileStatus/success'
      end

      it 'should handle all attributes' do
        Paypal.logger.should_not_receive(:warn)
        request.renew! 'profile_id', :Cancel
      end
    end
  end

  describe "#to_s" do
    before do
      fake_response 'SetExpressCheckout/success'
    end

    it "should return a stringified hash of POST request response that instantiated the object" do
      response = request.setup(payment_request, return_url, cancel_url)

      expect(response.to_s).to eq("{:ACK=>\"Success\", :BUILD=>\"1721431\", :CORRELATIONID=>\"5549ea3a78af1\", :TIMESTAMP=>\"2011-02-02T02:02:18Z\", :TOKEN=>\"EC-5YJ90598G69065317\", :VERSION=>\"66.0\"}")
    end
  end

end
