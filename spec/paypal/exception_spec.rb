require 'spec_helper.rb'

describe Paypal::Exception::HttpError do
  it 'should have code, message and body' do
    error = Paypal::Exception::HttpError.new(400, 'BadRequest', 'You are bad man!')
  end
end

describe Paypal::Exception::APIError do
end