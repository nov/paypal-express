require 'spec_helper.rb'

describe Paypal::Payment::Response::Info do
  let :attributes do
    {
      :NAME => 'Item Name',
      :DESC => 'Item Description',
      :QTY => '1',
      :ITEMCATEGORY => 'Digital',
      :ITEMWIDTHVALUE => '1.0',
      :ITEMHEIGHTVALUE => '2.0',
      :ITEMLENGTHVALUE => '3.0',
      :ITEMWEIGHTVALUE => '4.0'
    }
  end

  describe '.new' do
    subject { Paypal::Payment::Response::Item.new(attributes) }
    its(:name) { should == 'Item Name' }
    its(:description) { should == 'Item Description' }
    its(:quantity) { should == 1 }
    its(:category) { should == 'Digital' }
    its(:width) { should == '1.0' }
    its(:height) { should == '2.0' }
    its(:length) { should == '3.0' }
    its(:weight) { should == '4.0' }

    context 'when non-supported attributes are given' do
      it 'should ignore them and warn' do
        _attr_ = attributes.merge(
          :ignored => 'Ignore me!'
        )
        Paypal.logger.should_receive(:warn).with(
          "Ignored Parameter (Paypal::Payment::Response::Item): ignored=Ignore me!"
        )
        Paypal::Payment::Response::Item.new _attr_
      end
    end
  end
end