describe Paypal::NVP::Request do
  let :attributes do
    {
      :username => 'nov',
      :password => 'password',
      :signature => 'sig'
    }
  end

  let :instance do
    Paypal::NVP::Request.new attributes
  end

  describe '.new' do
    context 'when any required parameters are missing' do
      it 'should raise AttrRequired::AttrMissing' do
        attributes.keys.each do |missing_key|
          insufficient_attributes = attributes.reject do |key, value|
            key == missing_key
          end
          expect do
            Paypal::NVP::Request.new insufficient_attributes
          end.to raise_error AttrRequired::AttrMissing
        end
      end
    end

    context 'when all required parameters are given' do
      it 'should succeed' do
        expect do
          Paypal::NVP::Request.new attributes
        end.not_to raise_error AttrRequired::AttrMissing
      end

      it 'should setup endpoint and version' do
        client = Paypal::NVP::Request.new attributes
        client.class.endpoint.should == Paypal::NVP::Request::ENDPOINT[:production]
      end

      it 'should support sandbox mode' do
        sandbox_mode do
          client = Paypal::NVP::Request.new attributes
          client.class.endpoint.should == Paypal::NVP::Request::ENDPOINT[:sandbox]
        end
      end
    end

    context 'when optional parameters are given' do
      let(:optional_attributes) do
        { :subject => 'user@example.com' }
      end

      it 'should setup subject' do
        client = Paypal::NVP::Request.new attributes.merge(optional_attributes)
        client.subject.should == 'user@example.com'
      end
    end
  end

  describe '#common_params' do
    {
      :username => :USER,
      :password => :PWD,
      :signature => :SIGNATURE,
      :subject => :SUBJECT,
      :version => :VERSION
    }.each do |option_key, param_key|
      it "should include :#{param_key}" do
        instance.common_params.should include(param_key)
      end

      it "should set :#{param_key} as #{option_key}" do
        instance.common_params[param_key].should == instance.send(option_key)
      end
    end
  end

  describe '#request' do
    it 'should POST to NPV endpoint' do
      expect do
        instance.request(:RPCMethod)
      end.to request_to(Paypal::NVP::Request::ENDPOINT[:production], :post)
    end

    context 'when got API error response' do
      subject { instance.request(:SetExpressCheckout) }
      before { fake_response 'SetExpressCheckout/failure' }

      it 'does not raise, returns the response object to be handled' do
        expect{ subject }.to_not raise_error
        expect(subject).to eq({
          :ACK => "Failure",
          :CORRELATIONID => "379d1b7f97afb",
          :L_ERRORCODE0 => "10001",
          :L_LONGMESSAGE0 => "Timeout processing request",
          :L_SHORTMESSAGE0 => "Internal Error",
          :TIMESTAMP => "2011-02-02T02:16:50Z"
        })
      end
    end

    context 'when got HTTP error response' do
      before do
        FakeWeb.register_uri(
          :post,
          Paypal::NVP::Request::ENDPOINT[:production],
          :body => "Invalid Request",
          :status => ["400", "Bad Request"]
        )
      end

      it 'should raise Paypal::Exception::HttpError' do
        expect do
          instance.request :SetExpressCheckout
        end.to raise_error(Paypal::Exception::HttpError)
      end
    end
  end
end
