require 'spec_helper'

describe Paypal::IPN do
  describe '.verify!' do
    context 'when valid' do
      before do
        fake_response 'IPN/valid', :IPN
      end

      it 'should return true' do
        Paypal::IPN.verify!("raw-post-body").should be_true
      end
    end

    context 'when invalid' do
      before do
        fake_response 'IPN/invalid', :IPN
      end

      it 'should raise Paypal::APIError' do
        lambda do
          Paypal::IPN.verify!("raw-post-body")
        end.should raise_error(Paypal::APIError)
      end
    end
  end
end