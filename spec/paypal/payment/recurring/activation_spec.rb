require 'spec_helper'

describe Paypal::Payment::Recurring::Activation do
  let :instance do
    Paypal::Payment::Recurring::Activation.new(
      :initial_amount => 100,
      :failed_action => 'ContinueOnFailure'
    )
  end

  describe '#to_params' do
    it 'should handle Recurring Profile activation parameters' do
      instance.to_params.should == {
        :INITAMT => '100.00',
        :FAILEDINITAMTACTION => 'ContinueOnFailure'
      }
    end
  end
end