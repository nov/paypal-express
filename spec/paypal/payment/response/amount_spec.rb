require 'spec_helper.rb'

describe Paypal::Payment::Response::Amount, '.new' do
  let(:attributes) do
    {}
  end
  let(:keys) do
    Paypal::Payment::Response::Amount.optional_attributes
  end

  it 'should not allow nil for attributes' do
    amount = Paypal::Payment::Response::Amount.new attributes
    keys.each do |key|
      amount.send(key).should == 0
    end
  end

  it 'should treat all attributes as Numeric' do
    # Integer
    keys.each do |key|
      attributes[key] = "100"
    end
    amount = Paypal::Payment::Response::Amount.new attributes
    keys.each do |key|
      amount.send(key).should == 100
    end

    # Float
    keys.each do |key|
      attributes[key] = "10.25"
    end
    amount = Paypal::Payment::Response::Amount.new attributes
    keys.each do |key|
      amount.send(key).should == 10.25
    end
  end
end