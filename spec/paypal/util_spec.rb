require 'spec_helper.rb'

describe Paypal::Util do
  describe '.formatted_amount' do
    it 'should return String in "xx.yy" format' do
      Paypal::Util.formatted_amount(nil).should == '0.00'
      Paypal::Util.formatted_amount(10).should == '10.00'
      Paypal::Util.formatted_amount(BigDecimal('10.02')).should == '10.02'
      Paypal::Util.formatted_amount(BigDecimal('10.2')).should == '10.20'
      Paypal::Util.formatted_amount(BigDecimal('10.24')).should == '10.24'
      Paypal::Util.formatted_amount(BigDecimal('10.255')).should == '10.25'
    end
  end

  describe '.to_numeric' do
    it 'should return Integer or BigDecimal' do
      Paypal::Util.to_numeric('10').should be_kind_of(Integer)
      Paypal::Util.to_numeric('10.5').should be_kind_of(BigDecimal)
      Paypal::Util.to_numeric('-1.5').should == BigDecimal('-1.5')
      Paypal::Util.to_numeric('-1').should == -1
      Paypal::Util.to_numeric('0').should == 0
      Paypal::Util.to_numeric('0.00').should == 0
      Paypal::Util.to_numeric('10').should == 10
      Paypal::Util.to_numeric('10.00').should == 10
      Paypal::Util.to_numeric('10.02').should == BigDecimal('10.02')
      Paypal::Util.to_numeric('10.2').should == BigDecimal('10.2')
      Paypal::Util.to_numeric('10.20').should == BigDecimal('10.2')
      Paypal::Util.to_numeric('10.24').should == BigDecimal('10.24')
      Paypal::Util.to_numeric('10.25').should == BigDecimal('10.25')
    end
  end
end
