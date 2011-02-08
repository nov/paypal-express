require 'spec_helper.rb'

describe Paypal::Payment::Response::Payer, '.new' do
  let :keys do
    Paypal::Payment::Response::Payer.optional_attributes
  end

  it 'should allow nil for attributes' do
    payer = Paypal::Payment::Response::Payer.new
    keys.each do |key|
      payer.send(key).should be_nil
    end
  end

  it 'should treat all attributes as String' do
    attributes = keys.inject({}) do |attributes, key|
      attributes.merge!(key => "xyz")
    end
    payer = Paypal::Payment::Response::Payer.new attributes
    keys.each do |key|
      payer.send(key).should == "xyz"
    end
  end
end