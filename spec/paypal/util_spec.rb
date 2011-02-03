require 'spec_helper.rb'

describe Paypal::Util, '.formatted_amount' do
  it 'should return String in "xx.yy" format' do
    Paypal::Util.formatted_amount(nil).should == '0.00'
    Paypal::Util.formatted_amount(10).should == '10.00'
    Paypal::Util.formatted_amount(10.2).should == '10.20'
    Paypal::Util.formatted_amount(10.24).should == '10.24'
    Paypal::Util.formatted_amount(10.255).should == '10.25'
  end
end

describe Paypal::Util, '.numeric_amount' do
  it 'should return Numeric' do
    Paypal::Util.numeric_amount('0').should == 0
    Paypal::Util.numeric_amount('0.00').should == 0
    Paypal::Util.numeric_amount('10').should == 10
    Paypal::Util.numeric_amount('10.00').should == 10
    Paypal::Util.numeric_amount('10.2').should == 10.2
    Paypal::Util.numeric_amount('10.20').should == 10.2
    Paypal::Util.numeric_amount('10.24').should == 10.24
    Paypal::Util.numeric_amount('10.25').should == 10.25
  end
end