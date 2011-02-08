require 'spec_helper.rb'

describe Paypal::Payment::Response::Amount do
  let :keys do
    Paypal::Payment::Response::Amount.optional_attributes
  end

  describe '.new' do
    it 'should not allow nil for attributes' do
      amount = Paypal::Payment::Response::Amount.new
      keys.each do |key|
        amount.send(key).should == 0
      end
    end

    it 'should treat all attributes as Numeric' do
      # Integer
      attributes = keys.inject({}) do |attributes, key|
        attributes.merge!(key => "100")
      end
      amount = Paypal::Payment::Response::Amount.new attributes
      keys.each do |key|
        amount.send(key).should == 100
      end

      # Float
      attributes = keys.inject({}) do |attributes, key|
        attributes.merge!(key => "10.25")
      end
      amount = Paypal::Payment::Response::Amount.new attributes
      keys.each do |key|
        amount.send(key).should == 10.25
      end
    end
  end
end