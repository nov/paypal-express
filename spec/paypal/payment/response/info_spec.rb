require 'spec_helper.rb'

describe Paypal::Payment::Response::Info do
  let :attribute_mapping do
    Paypal::Payment::Response::Info.attribute_mapping
  end

  let :attributes do
    {
      :ACK => 'Success',
      :CURRENCYCODE => 'JPY',
      :ERRORCODE => 0,
      :ORDERTIME => '2011-02-08T03:23:54Z',
      :PAYMENTSTATUS => 'Completed',
      :PAYMENTTYPE => 'instant',
      :PENDINGREASON => 'None',
      :PROTECTIONELIGIBILITY => 'Ineligible',
      :PROTECTIONELIGIBILITYTYPE => 'None',
      :REASONCODE => 'None',
      :TRANSACTIONID => '8NC65222871997739',
      :TRANSACTIONTYPE => 'expresscheckout',
      :AMT => '14.00',
      :FEEAMT => '0.85',
      :TAXAMT => '0.00',
      :RECEIPTID => '12345',
      :SECUREMERCHANTACCOUNTID => '123456789',
      :PAYMENTREQUESTID => '12345',
      :SELLERPAYPALACCOUNTID => 'seller@shop.example.com'
    }
  end

  describe '.new' do
    context 'when attribute keys are uppercase Symbol' do
      it 'should accept all without any warning' do
        Paypal.logger.should_not_receive(:warn)
        from_symbol_uppercase = Paypal::Payment::Response::Info.new attributes
        attribute_mapping.values.each do |key|
          from_symbol_uppercase.send(key).should_not be_nil
        end
        from_symbol_uppercase.amount.should == Paypal::Payment::Common::Amount.new(
          :total => 14,
          :fee => 0.85
        )
      end
    end

    context 'when attribute keys are lowercase Symbol' do
      it 'should ignore them and warn' do
        _attrs_ = attributes.inject({}) do |_attrs_, (k, v)|
          _attrs_.merge!(k.to_s.downcase.to_sym => v)
        end
        _attrs_.each do |key, value|
          Paypal.logger.should_receive(:warn).with(
            "Ignored Parameter (Paypal::Payment::Response::Info): #{key}=#{value}"
          )
        end
        from_symbol_lowercase = Paypal::Payment::Response::Info.new _attrs_
        attribute_mapping.values.each do |key|
          from_symbol_lowercase.send(key).should be_nil
        end
        from_symbol_lowercase.amount.should == Paypal::Payment::Common::Amount.new
      end
    end

    context 'when attribute keys are String' do
      it 'should ignore them and warn' do
        attributes.stringify_keys.each do |key, value|
          Paypal.logger.should_receive(:warn).with(
            "Ignored Parameter (Paypal::Payment::Response::Info): #{key}=#{value}"
          )
        end
        from_string = Paypal::Payment::Response::Info.new attributes.stringify_keys
        attribute_mapping.values.each do |key|
          from_string.send(key).should be_nil
        end
        from_string.amount.should == Paypal::Payment::Common::Amount.new
      end
    end

    context 'when non-supported attributes are given' do
      it 'should ignore them and warn' do
        _attr_ = attributes.merge(
          :ignored => 'Ignore me!'
        )
        Paypal.logger.should_receive(:warn).with(
          "Ignored Parameter (Paypal::Payment::Response::Info): ignored=Ignore me!"
        )
        Paypal::Payment::Response::Info.new _attr_
      end
    end
  end
end