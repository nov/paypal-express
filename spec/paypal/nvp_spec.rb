require 'spec_helper.rb'

describe Paypal::NVP, '.new' do

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
          Paypal::NVP.new insufficient_attributes
        end.should raise_error Paypal::AttrMissing
      end
    end
  end

  context 'when all required parameters are given' do
    it 'should succeed' do
      lambda do
        Paypal::NVP.new required_params
      end.should_not raise_error Paypal::AttrMissing
    end

    it 'should setup endpoint and version' do
      client = Paypal::NVP.new required_params
      client.version.should == Paypal::API_VERSION
      client.endpoint.should == Paypal::NVP::ENDPOINT[:production]
    end

    it 'should support sandbox mode' do
      client = Paypal::NVP.new required_params.merge(:sandbox => true)
      client.endpoint.should == Paypal::NVP::ENDPOINT[:sandbox]
    end
  end

end