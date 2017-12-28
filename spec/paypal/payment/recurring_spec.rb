# rspec spec/paypal/payment/recurring_spec.rb
describe Paypal::Payment::Recurring do
  klass = Paypal::Payment::Recurring

  let :keys do
    Paypal::Payment::Recurring.optional_attributes
  end

  let :trial_attributes do
    {}
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
        :trial => trial_attributes
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
    klass.new(attributes)
  end

  describe '.new' do
    # can not make this happen as profile object is used both in cretion, response verification and status checks, which vary in available parameters
    xit "should raise if attempting to initialize with missing mandatory parameters" do
      expect{klass.new({raw: {:DESC => "test description"}})}.to raise_error(ArgumentError, /\AMissing mandatory parameters \[:PROFILESTARTDATE, :BILLINGPERIOD, :BILLINGFREQUENCY, :AMT, :CURRENCYCODE\]/)
    end

    xit "should not raise if initializing with all mandatory parameters" do
      mandatory_parameters = {
        :DESC => "Funny Movie Clips Subscription",
        :PROFILESTARTDATE => "2017-01-25T15:00:00Z",
        :BILLINGPERIOD => "Day", # "Month", "Year"
        :BILLINGFREQUENCY => "30",
        :AMT => "9.00", # two-decimals for cents, whole number for whole currency, like a Euro or Dollar
        :CURRENCYCODE => "EUR",
      }

      expect{klass.new(raw: mandatory_parameters)}.to_not raise_error(ArgumentError)
    end

    it 'should accept all supported attributes' do
      instance.identifier.should == '12345'
      instance.description.should == 'Subscription Payment Profile'
      instance.status.should == 'Active'
      instance.start_date.should == '2011-02-03T15:00:00Z'
      instance.billing.trial.should be_nil
    end

    context 'when optional trial info given' do
      let :trial_attributes do
        {
          :period => 'Month',
          :frequency => '1',
          :total_cycles => '0',
          :currency_code => 'JPY',
          :amount => '1000',
          :shipping_amount => '0',
          :tax_amount => '0'
        }
      end

      it 'should setup trial billing info' do
        instance.billing.trial.should == Paypal::Payment::Recurring::Billing.new(trial_attributes)
      end
    end
  end

  describe '#to_params' do
    it 'should handle Recurring Profile parameters' do
      instance.to_params.should == {
        :AUTOBILLOUTAMT => 'NoAutoBill',
        :BILLINGFREQUENCY => 1,
        :SHIPPINGAMT => '0.00',
        :DESC => 'Subscription Payment Profile',
        :SUBSCRIBERNAME => 'Nov Matake',
        :BILLINGPERIOD => 'Month',
        :AMT => '1000.00',
        :MAXFAILEDPAYMENTS => 0,
        :TOTALBILLINGCYCLES => 0,
        :TAXAMT => '0.00',
        :PROFILESTARTDATE => '2011-02-03T15:00:00Z',
        :CURRENCYCODE => 'JPY'
      }
    end

    context 'when start_date is a Time object' do
      it 'should get correctly stringfied when converting to params' do
        instance = Paypal::Payment::Recurring.new(
          attributes.merge(
            :start_date => Time.utc(2011, 2, 8, 15, 0, 0)
          )
        )

        instance.start_date.should be_instance_of(Time)
        instance.to_params[:PROFILESTARTDATE].should == '2011-02-08 15:00:00'
      end
    end

    context 'when optional trial setting given' do
      let :trial_attributes do
        {
          :period => 'Month',
          :frequency => '1',
          :total_cycles => '0',
          :currency_code => 'JPY',
          :amount => '1000',
          :shipping_amount => '0',
          :tax_amount => '0'
        }
      end

      it 'should setup trial billing info' do
        instance.to_params.should == {
          :TRIALBILLINGPERIOD => "Month",
          :TRIALBILLINGFREQUENCY => 1,
          :TRIALTOTALBILLINGCYCLES => 0,
          :TRIALAMT => "1000.00",
          :TRIALCURRENCYCODE => "JPY",
          :TRIALSHIPPINGAMT => "0.00",
          :TRIALTAXAMT => "0.00",
          :BILLINGPERIOD => "Month",
          :BILLINGFREQUENCY => 1,
          :TOTALBILLINGCYCLES => 0,
          :AMT => "1000.00",
          :CURRENCYCODE => "JPY",
          :SHIPPINGAMT => "0.00",
          :TAXAMT => "0.00",
          :DESC => "Subscription Payment Profile",
          :MAXFAILEDPAYMENTS => 0,
          :AUTOBILLOUTAMT => "NoAutoBill",
          :PROFILESTARTDATE => "2011-02-03T15:00:00Z",
          :SUBSCRIBERNAME => "Nov Matake"
        }
      end
    end

    context "when attempting to initialize a Recurring Profile with an initial payment now and same payments every month" do
      it "should return correct request parameters hash" do
        @attributes = expected_recurring_profile_parameters

        profile = Paypal::Payment::Recurring.new(raw: @attributes)

        @exp = expected_recurring_profile_parameters

        expect(profile.to_params).to eq @exp
      end
    end

    context "when attempting to initialize a Recurring Profile with a large initial payment now and smaller payments every month" do
      it "should return correct request parameters hash" do
        @attributes = mandatory_profile_parameters.merge(initial_payment_profile_parameters).merge(auxilary_profile_parameters).merge(:INITAMT => "100.00", :AMT => "1.50")

        profile = Paypal::Payment::Recurring.new(raw: @attributes)

        @exp = mandatory_profile_parameters.merge(initial_payment_profile_parameters).merge(auxilary_profile_parameters).merge(:INITAMT => "100.00", :AMT => "1.50")

        expect(profile.to_params).to eq @exp
      end
    end

    context "when attempting to initialize a Recurring Profile with no initial payment and recurring payments every month starting in a week" do
      it "should return correct request parameters hash" do
        @attributes = mandatory_profile_parameters.merge(trial_profile_parameters).merge(auxilary_profile_parameters)

        profile = Paypal::Payment::Recurring.new(raw: @attributes)

        @exp = mandatory_profile_parameters.merge(trial_profile_parameters).merge(auxilary_profile_parameters)

        expect(profile.to_params).to eq @exp
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
