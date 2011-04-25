require 'spec_helper.rb'

describe Paypal::Payment::Request do
  let :instant_request do
    Paypal::Payment::Request.new(
      :amount => 25.7,
      :tax_amount => 0.4,
      :shipping_amount => 1.5,
      :currency_code => :JPY,
      :description => 'Instant Payment Request',
      :notify_url => 'http://merchant.example.com/notify',
      :items => [{
        :quantity => 2,
        :name => 'Item1',
        :description => 'Awesome Item 1!',
        :amount => 10.25
      }, {
        :quantity => 3,
        :name => 'Item2',
        :description => 'Awesome Item 2!',
        :amount => 1.1
      }]
    )
  end

  let :recurring_request do
    Paypal::Payment::Request.new(
      :currency_code => :JPY,
      :billing_type => :RecurringPayments,
      :billing_agreement_description => 'Recurring Payment Request'
    )
  end

  describe '.new' do
    it 'should handle Instant Payment parameters' do
      instant_request.amount.total.should == 25.7
      instant_request.amount.tax.should == 0.4
      instant_request.amount.shipping.should == 1.5
      instant_request.currency_code.should == :JPY
      instant_request.description.should == 'Instant Payment Request'
      instant_request.notify_url.should == 'http://merchant.example.com/notify'
    end

    it 'should handle Recurring Payment parameters' do
      recurring_request.currency_code.should == :JPY
      recurring_request.billing_type.should == :RecurringPayments
      recurring_request.billing_agreement_description.should == 'Recurring Payment Request'
    end
  end

  describe '#to_params' do
    it 'should handle Instant Payment parameters' do
      instant_request.to_params.should == {
        :PAYMENTREQUEST_0_AMT => "25.70",
        :PAYMENTREQUEST_0_TAXAMT => "0.40",
        :PAYMENTREQUEST_0_SHIPPINGAMT => "1.50",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :PAYMENTREQUEST_0_DESC => "Instant Payment Request", 
        :PAYMENTREQUEST_0_NOTIFYURL => "http://merchant.example.com/notify",
        :PAYMENTREQUEST_0_ITEMAMT => "23.80",
        :L_PAYMENTREQUEST_0_NAME0 => "Item1",
        :L_PAYMENTREQUEST_0_DESC0 => "Awesome Item 1!",
        :L_PAYMENTREQUEST_0_AMT0 => "10.25",
        :L_PAYMENTREQUEST_0_QTY0 => 2,
        :L_PAYMENTREQUEST_0_NAME1 => "Item2",
        :L_PAYMENTREQUEST_0_DESC1 => "Awesome Item 2!",
        :L_PAYMENTREQUEST_0_AMT1 => "1.10",
        :L_PAYMENTREQUEST_0_QTY1 => 3
      }
    end

    it 'should handle Recurring Payment parameters' do
      recurring_request.to_params.should == {
        :PAYMENTREQUEST_0_AMT => "0.00",
        :PAYMENTREQUEST_0_TAXAMT => "0.00",
        :PAYMENTREQUEST_0_SHIPPINGAMT => "0.00",
        :PAYMENTREQUEST_0_CURRENCYCODE => :JPY,
        :L_BILLINGTYPE0 => :RecurringPayments,
        :L_BILLINGAGREEMENTDESCRIPTION0 => "Recurring Payment Request"
      }
    end
  end
end
