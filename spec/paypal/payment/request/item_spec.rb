require 'spec_helper.rb'

describe Paypal::Payment::Request::Item do
  let :instance do
    Paypal::Payment::Request::Item.new(
      :name => 'Name',
      :description => 'Description',
      :amount => 10,
      :quantity => 5,
      :category => :Digital,
      :number => '1'
    )
  end

  describe '#to_params' do
    it 'should handle Recurring Profile activation parameters' do
      instance.to_params(1).should == {
        :L_PAYMENTREQUEST_1_NAME0 => 'Name',
        :L_PAYMENTREQUEST_1_DESC0 => 'Description',
        :L_PAYMENTREQUEST_1_AMT0 => '10.00',
        :L_PAYMENTREQUEST_1_QTY0 => 5,
        :L_PAYMENTREQUEST_1_ITEMCATEGORY0 => :Digital,
        :L_PAYMENTREQUEST_1_NUMBER0 => '1'
      }
    end
  end
end