require 'spec_helper.rb'

describe Paypal::Payment::Response::Info, '.new' do
  let :attribute_mapping do
    {
      :ACK => :ack,
      :CURRENCYCODE => :currency_code,
      :ERRORCODE => :error_code,
      :ORDERTIME => :order_time,
      :PAYMENTSTATUS => :payment_status,
      :PAYMENTTYPE => :payment_type,
      :PENDINGREASON => :pending_reason,
      :PROTECTIONELIGIBILITY => :protection_eligibility,
      :PROTECTIONELIGIBILITYTYPE => :protection_eligibility_type,
      :REASONCODE => :reason_code,
      :TRANSACTIONID => :transaction_id,
      :TRANSACTIONTYPE => :transaction_type
    }
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
      :TAXAMT => '0.00'
    }
  end

  it 'should accept uppercase symbol as attribute keys' do
    from_symbol_uppercase = Paypal::Payment::Response::Info.new attributes
    attribute_mapping.values.each do |key|
      from_symbol_uppercase.send(key).should_not be_nil
    end
    from_symbol_uppercase.amount.should == Paypal::Payment::Response::Amount.new(
      :total => 14,
      :fee => 0.85
    )
  end

  it 'should not accept lower symbol as attribute keys' do
    _attrs_ = attributes.inject({}) do |attrs, (k, v)|
      attrs[k.to_s.downcase.to_sym] = v
      attrs
    end
    from_symbol_lowercase = Paypal::Payment::Response::Info.new _attrs_
    attribute_mapping.values.each do |key|
      from_symbol_lowercase.send(key).should be_nil
    end
    from_symbol_lowercase.amount.should == Paypal::Payment::Response::Amount.new
  end

  it 'should not string as attribute keys' do
    from_string = Paypal::Payment::Response::Info.new attributes.stringify_keys
    attribute_mapping.values.each do |key|
      from_string.send(key).should be_nil
    end
    from_string.amount.should == Paypal::Payment::Response::Amount.new
  end

end