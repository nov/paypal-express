require 'spec_helper.rb'

describe Paypal::Payment::Response::Address do
  let :keys do
    Paypal::Payment::Response::Address.optional_attributes
  end

  describe '.new' do
    it 'should allow nil for attributes' do
      payer = Paypal::Payment::Response::Address.new
      keys.each do |key|
        payer.send(key).should be_nil
      end
    end

    it 'should treat all attributes as String' do
      attributes = keys.inject({}) do |attributes, key|
        attributes.merge!(key => "xyz")
      end
      payer = Paypal::Payment::Response::Address.new attributes
      keys.each do |key|
        payer.send(key).should == "xyz"
      end
    end
  end
end