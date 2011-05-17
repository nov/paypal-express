require 'spec_helper.rb'

describe Paypal::Payment::Recurring do
  let :keys do
    Paypal::Payment::Recurring.optional_attributes
  end

  let :attributes do
    {
      :identifier => '12345',
      :description => 'Subscription Payment Profile',
      :status => 'Active',
      :start_date => '2011-02-03T15:00:00Z',
      :name => 'Nov Matake',
      :auto_bill => 'NoAutoBill',
      :max_fails => '0',
      :aggregate_amount => '1000',
      :aggregate_optional_amount => '0',
      :final_payment_date => '1970-01-01T00:00:00Z',
      :billing => {
        :amount => Paypal::Payment::Common::Amount.new(
          :total => '1000',
          :shipping => '0',
          :tax => '0'
        ),
        :currency_code => 'JPY',
        :period => 'Month',
        :frequency => '1',
        :total_cycles => '0',
        :trial_amount_paid => '0'
      },
      :regular_billing => {
        :amount => '1000',
        :shipping_amount => '0',
        :tax_amount => '0',
        :currency_code => 'JPY',
        :period => 'Month',
        :frequency => '1',
        :total_cycles => '0',
        :paid => '1000'
      },
      :summary => {
        :next_billing_date => '2011-03-04T10:00:00Z',
        :cycles_completed => '1',
        :cycles_remaining => '18446744073709551615',
        :outstanding_balance => '0',
        :failed_count => '0',
        :last_payment_date => '2011-02-04T10:50:56Z',
        :last_payment_amount => '1000'
      }
    }
  end

  let :instance do
    Paypal::Payment::Recurring.new attributes
  end

  describe '.new' do
    it 'should accept all supported attributes' do
      instance.identifier.should == '12345'
      instance.description.should == 'Subscription Payment Profile'
      instance.status.should == 'Active'
      instance.start_date.should == '2011-02-03T15:00:00Z'
    end
  end

  describe '#to_params' do
    it 'should handle Recurring Profile parameters' do
      instance.to_params.should == {
        :AUTOBILLOUTAMT => 'NoAutoBill',
        :BILLINGFREQUENCY => 1,
        :TRIALTOTALBILLINGCYCLES => 0,
        :SHIPPINGAMT => '0.00',
        :DESC => 'Subscription Payment Profile',
        :SUBSCRIBERNAME => 'Nov Matake',
        :BILLINGPERIOD => 'Month',
        :AMT => '1000.00',
        :MAXFAILEDPAYMENTS => 0,
        :TOTALBILLINGCYCLES => 0,
        :TRIALBILLINGFREQUENCY => 0,
        :TAXAMT => '0.00',
        :TRIALAMT => '0.00',
        :PROFILESTARTDATE => '2011-02-03T15:00:00Z',
        :CURRENCYCODE => 'JPY'
      }
    end

    context 'when start_date is Time' do
      it 'should be stringfy' do
        instance = Paypal::Payment::Recurring.new attributes.merge(
          :start_date => Time.utc(2011, 2, 8, 15, 0, 0)
        )
        instance.start_date.should be_instance_of(Time)
        instance.to_params[:PROFILESTARTDATE].should == '2011-02-08 15:00:00'
      end
    end
  end

  describe '#numeric_attribute?' do
    let :numeric_attributes do
      [:aggregate_amount, :aggregate_optional_amount, :max_fails, :failed_count]
    end

    it 'should detect numeric attributes' do
      numeric_attributes.each do |key|
        instance.numeric_attribute?(key).should be_true
      end
      non_numeric_keys = keys - numeric_attributes
      non_numeric_keys.each do |key|
        instance.numeric_attribute?(key).should be_false
      end
    end
  end
end