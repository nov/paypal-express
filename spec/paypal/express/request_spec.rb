require 'spec_helper.rb'

describe Paypal::Express::Request do
  let :attributes do
    {
      :username => 'nov',
      :password => 'password',
      :signature => 'sig',
      :return_url => 'http://example.com/success',
      :cancel_url => 'http://example.com/cancel'
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
end