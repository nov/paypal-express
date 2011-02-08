require 'spec_helper.rb'

describe Paypal::NVP::Request do
  let :attributes do
    {
      :username => 'nov',
      :password => 'password',
      :signature => 'sig'
    }
  end

  describe '.new' do
    context 'when any required parameters are missing' do
      it 'should raise AttrMissing exception' do
        attributes.keys.each do |missing_key|
          insufficient_attributes = attributes.reject do |key, value|
            key == missing_key
          end
          lambda do
            Paypal::NVP::Request.new insufficient_attributes
          end.should raise_error AttrRequired::AttrMissing
        end
      end
    end

    context 'when all required parameters are given' do
      it 'should succeed' do
        lambda do
          Paypal::NVP::Request.new attributes
        end.should_not raise_error AttrRequired::AttrMissing
      end

      it 'should setup endpoint and version' do
        client = Paypal::NVP::Request.new attributes
        client.version.should == Paypal::API_VERSION
        client.endpoint.should == Paypal::NVP::Request::ENDPOINT[:production]
      end

      it 'should support sandbox mode' do
        sandbox_mode do
          client = Paypal::NVP::Request.new attributes
          client.endpoint.should == Paypal::NVP::Request::ENDPOINT[:sandbox]
        end
      end
    end
  end
end