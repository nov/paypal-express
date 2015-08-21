module Paypal
  module Express
    class Request < NVP::Request

      ATTRIBUTES_TO_KEYS = {
        :currency_code     => :CURRENCYCODE,
        :invoice_number    => :INVNUM,
        :description       => :DESC,
        :msg_submission_id => :MSGSUBID,
        :custom            => :CUSTOM,
        :note              => :NOTE,
        :invoice_id        => :INVOICEID,
        :solution_type     => :SOLUTIONTYPE,
        :landing_page      => :LANDINGPAGE,
        :email             => :EMAIL,
        :brand             => :BRANDNAME,
        :locale            => :LOCALECODE,
        :logo              => :LOGOIMG,
        :cart_border_color => :CARTBORDERCOLOR,
        :payflow_color     => :PAYFLOWCOLOR
      }

      # Common

      def setup(payment_requests, return_url, cancel_url, options = {})
        params = {
          :RETURNURL => return_url,
          :CANCELURL => cancel_url
        }
        if options.delete(:no_shipping)
          params[:REQCONFIRMSHIPPING] = 0
          params[:NOSHIPPING] = 1
        end

        params[:ALLOWNOTE] = 0 if options.delete(:allow_note) == false

        params = translated_params(options).merge(params)
        Array(payment_requests).each_with_index do |payment_request, index|
          params.merge! payment_request.to_params(index)
        end
        response = self.request :SetExpressCheckout, params
        Response.new response, options
      end

      def details(token)
        response = self.request :GetExpressCheckoutDetails, {:TOKEN => token}
        Response.new response
      end

      # Now with support for passing subject to lookup.
      # SUBJECT is used when looking up transactions on behalf of other accounts
      # that have given you API permission access.
      # Grab the details of an individual transaction via the GetTransactionDetails method.
      #
      # @param [String] transaction_id The individual transaction ID. Note that many payments contain multiple transactions.
      # @param [String] subject = nil Pass an option PayPal merchant ID when looking up transactions on other accounts you have permission to search.
      # @return [Paypal::Express::Response]
      def transaction_details(transaction_id, subject = nil)
        params = {:TRANSACTIONID=> transaction_id}
        params[:SUBJECT] = subject unless subject.nil?

        response = self.request :GetTransactionDetails, params
        Response.new response
      end

      def checkout!(token, payer_id, payment_requests, options = {})
        params = {
          :TOKEN => token,
          :PAYERID => payer_id
        }
        params = translated_params(options).merge(params)
        Array(payment_requests).each_with_index do |payment_request, index|
          params.merge! payment_request.to_params(index)
        end
        response = self.request :DoExpressCheckoutPayment, params
        Response.new response
      end

      def capture!(authorization_id, amount, currency_code, complete_type = 'Complete')
        params = {
          :AUTHORIZATIONID => authorization_id,
          :COMPLETETYPE => complete_type,
          :AMT => amount,
          :CURRENCYCODE => currency_code
        }

        response = self.request :DoCapture, params
        Response.new response
      end

      def void!(authorization_id, params={})
        params = {
          :AUTHORIZATIONID => authorization_id,
          :NOTE => params[:note]
        }

        response = self.request :DoVoid, params
        Response.new response
      end

      # Recurring Payment Specific

      def subscribe!(token, recurring_profile)
        params = {
          :TOKEN => token
        }
        params.merge! recurring_profile.to_params
        response = self.request :CreateRecurringPaymentsProfile, params
        Response.new response
      end

      def subscription(profile_id)
        params = {
          :PROFILEID => profile_id
        }
        response = self.request :GetRecurringPaymentsProfileDetails, params
        Response.new response
      end

      def renew!(profile_id, action, options = {})
        params = {
          :PROFILEID => profile_id,
          :ACTION => action
        }
        response = self.request :ManageRecurringPaymentsProfileStatus, translated_params(options).merge(params)
        Response.new response
      end

      def suspend!(profile_id, options = {})
        renew!(profile_id, :Suspend, options)
      end

      def cancel!(profile_id, options = {})
        renew!(profile_id, :Cancel, options)
      end

      def reactivate!(profile_id, options = {})
        renew!(profile_id, :Reactivate, options)
      end

      # Reference Transaction Specific

      def agree!(token, options = {})
        params = {
          :TOKEN => token
        }

        response = self.request :CreateBillingAgreement, params
        Response.new response
      end

      def agreement(reference_id)
        params = {
          :REFERENCEID => reference_id
        }
        response = self.request :BillAgreementUpdate, params
        Response.new response
      end

      def charge!(reference_id, amount, options = {})
        # options.assert_valid_keys(:msgsubid, :payment_action, :currency_code, :ip_address...)

        params = {
          :REFERENCEID => reference_id,
          :AMT => Util.formatted_amount(amount),
          :PAYMENTACTION => options.delete(:payment_action) || :Sale
        }

        response = self.request :DoReferenceTransaction, translated_params(options).merge(params)
        Response.new response
      end

      def revoke!(reference_id)
        params = {
          :REFERENCEID => reference_id,
          :BillingAgreementStatus => :Canceled
        }
        response = self.request :BillAgreementUpdate, params
        Response.new response
      end

      # Refund Specific

      def refund!(transaction_id, options = {})
        params = {
          :TRANSACTIONID => transaction_id,
          :REFUNDTYPE => :Full
        }

        if options[:type]
          params[:REFUNDTYPE] = options.delete(:type)
          params[:AMT] = options.delete(:amount)
          params[:CURRENCYCODE] = options.delete(:currency_code)
        end
        response = self.request :RefundTransaction, translated_params(options).merge(params)
        Response.new response
      end

      private

      def translated_params(params)
        keys_to_replace = ATTRIBUTES_TO_KEYS.keys & params.keys

        keys_to_replace.each do |key, _value|
          params[ATTRIBUTES_TO_KEYS[key]] = params.delete(key)
        end

        if params[:max_amount]
          params[:MAXAMT] = Util.formatted_amount(params.delete([:max_amount]))
        end

        params
      end

    end
  end
end
