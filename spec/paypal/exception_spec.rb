require 'spec_helper.rb'

describe Paypal::HttpError do
  it 'should have code, message and body' do
    error = Paypal::HttpError.new(400, 'BadRequest', 'You are bad man!')
    error.code.should == 400
    error.message.should == 'BadRequest'
    error.body.should == 'You are bad man!'
  end
end

describe Paypal::APIError do
  it 'should have raw response' do
    error = Paypal::APIError.new({:error => 'ERROR!!'})
    error.response.should == {:error => 'ERROR!!'}
  end
end