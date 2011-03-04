require 'spec_helper.rb'

describe Paypal::Exception::HttpError do
  subject { Paypal::Exception::HttpError.new(400, 'BadRequest', 'You are bad man!') }
  its(:code)    { should == 400 }
  its(:message) { should == 'BadRequest' }
  its(:body)    { should == 'You are bad man!' }
end