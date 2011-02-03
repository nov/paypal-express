require 'spec_helper.rb'

describe Paypal::Payment::Response::ShipTo, '.new' do
  let(:attributes) do
    {}
  end
  let(:keys) do
    Paypal::Payment::Response::ShipTo.optional_attributes
  end

  it 'should allow nil for attributes' do
    payer = Paypal::Payment::Response::ShipTo.new attributes
    keys.each do |key|
      payer.send(key).should be_nil
    end
  end

  it 'should treat all attributes as String' do
    keys.each do |key|
      attributes[key] = "xyz"
    end
    payer = Paypal::Payment::Response::ShipTo.new attributes
    keys.each do |key|
      payer.send(key).should == "xyz"
    end
  end
end