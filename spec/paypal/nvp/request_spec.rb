require 'spec_helper.rb'

describe Paypal::NVP::Request, '.new' do

  let(:required_params) do
    {
      :username => 'nov',
      :password => 'password',
      :signature => 'sig'
    }
  end

  context 'when any required parameters are missing' do
    it 'should raise AttrMissing exception' do
      required_params.keys.each do |missing_key|
        insufficient_attributes = required_params.reject do |key, value|
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
        Paypal::NVP::Request.new required_params
      end.should_not raise_error AttrRequired::AttrMissing
    end

    it 'should setup endpoint and version' do
      client = Paypal::NVP::Request.new required_params
      client.version.should == Paypal::API_VERSION
      client.endpoint.should == Paypal::NVP::Request::ENDPOINT[:production]
    end

    it 'should support sandbox mode' do
      sandbox_mode do
        client = Paypal::NVP::Request.new required_params
        client.endpoint.should == Paypal::NVP::Request::ENDPOINT[:sandbox]
      end
    end
  end

end