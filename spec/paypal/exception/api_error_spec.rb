require 'spec_helper.rb'

describe Paypal::Exception::APIError do
  describe '.new' do
    let :error do
      Paypal::Exception::APIError.new response
    end

    context 'when Hash is given' do
      let :response do
        {
          :VERSION=>"66.0",
          :TIMESTAMP=>"2011-03-03T06:33:51Z",
          :CORRELATIONID=>"758ebdc546b9c",
          :L_SEVERITYCODE0=>"Error",
          :L_ERRORCODE0=>"10411",
          :L_LONGMESSAGE0=>"This Express Checkout session has expired.  Token value is no longer valid.",
          :BUILD=>"1741654",
          :ACK=>"Failure",
          :L_SHORTMESSAGE0=>"This Express Checkout session has expired."
        }
      end

      it 'should have Paypal::Exception::APIError::Response as response' do
        Paypal::Exception::APIError::Response.attribute_mapping.each do |key, value|
          error.response.send(value).should == response[key]
        end
      end

      it 'should have Paypal::Exception::APIError::Response::Detail as response.detail' do
        detail = error.response.details.first
        Paypal::Exception::APIError::Response::Detail.attribute_mapping.each do |key, value|
          detail.send(value).should == response[:"L_#{key}0"]
        end
      end

      it 'should have raw response as response.raw' do
        error.response.raw.should == response
      end

      context 'when unknown params given' do
        let :response do
          {
            :UNKNOWN => 'Unknown',
            :L_UNKNOWN0 => 'Unknown Detail'
          }
        end

        it 'should warn it and keep it only in response.raw' do
          Paypal.logger.should_receive(:warn).with(
            "Ignored Parameter (Paypal::Exception::APIError::Response): UNKNOWN=Unknown"
          )
          Paypal.logger.should_receive(:warn).with(
            "Ignored Parameter (Paypal::Exception::APIError::Response::Detail): UNKNOWN=Unknown Detail"
          )
          error
        end
      end
    end

    context 'otherwise' do
      let :response do
        'Failure'
      end

      it 'should store response in raw format' do
        error = Paypal::Exception::APIError.new response
        error.response.should == response
      end
    end
  end
  
end