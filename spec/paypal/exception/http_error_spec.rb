require 'spec_helper.rb'

describe Paypal::Exception::HttpError do
  it 'should have code, message and body' do
    error = Paypal::Exception::HttpError.new(400, 'BadRequest', 'You are bad man!')
    error.code.should == 400
    error.message.should == 'BadRequest'
    error.body.should == 'You are bad man!'
  end
end