module Paypal
  module Express
    class Request < NVP::Request

      # Common

      def setup(payment_requests, return_url, cancel_url, options = {})
        params = {
          :RETURNURL => return_url,
          :CANCELURL => cancel_url
        }
        if options[:no_shipping]
          params[:REQCONFIRMSHIPPING] = 0
          params[:NOSHIPPING] = 1
        end

        params[:ALLOWNOTE] = 0 if options[:allow_note] == false

        {
          :solution_type => :SOLUTIONTYPE,
          :landing_page  => :LANDINGPAGE,
          :email         => :EMAIL,
          :brand         => :BRANDNAME,
          :locale        => :LOCALECODE,
          :logo          => :LOGOIMG,
          :cart_border_color => :CARTBORDERCOLOR,
          :payflow_color => :PAYFLOWCOLOR
        }.each do |option_key, param_key|
          params[param_key] = options[option_key] if options[option_key]
        end
        Array(payment_requests).each_with_index do |payment_request, index|
          params.merge! payment_request.to_params(index)
        end
        response = self.request :SetExpressCheckout, params
        new_response response, options.merge(environment: environment)
      end

      def details(token)
        response = self.request :GetExpressCheckoutDetails, {:TOKEN => token}
        new_response response
      end

      def transaction_details(transaction_id)
        response = self.request :GetTransactionDetails, {:TRANSACTIONID=> transaction_id}
        new_response response
      end

      def checkout!(token, payer_id, payment_requests)
        params = {
          :TOKEN => token,
          :PAYERID => payer_id
        }
        Array(payment_requests).each_with_index do |payment_request, index|
          params.merge! payment_request.to_params(index)
        end
        response = self.request :DoExpressCheckoutPayment, params
        new_response response
      end

      def capture!(authorization_id, amount, currency_code, complete_type = 'Complete')
        params = {
          :AUTHORIZATIONID => authorization_id,
          :COMPLETETYPE => complete_type,
          :AMT => amount,
          :CURRENCYCODE => currency_code
        }

        response = self.request :DoCapture, params
        new_response response
      end

      def void!(authorization_id, params={})
        params = {
          :AUTHORIZATIONID => authorization_id,
          :NOTE => params[:note]
        }

        response = self.request :DoVoid, params
        new_response response
      end

      # Recurring Payment Specific

      def subscribe!(token, recurring_profile)
        params = {
          :TOKEN => token
        }
        params.merge! recurring_profile.to_params
        response = self.request :CreateRecurringPaymentsProfile, params
        new_response response
      end

      def subscription(profile_id)
        params = {
          :PROFILEID => profile_id
        }
        response = self.request :GetRecurringPaymentsProfileDetails, params
        new_response response
      end

      def renew!(profile_id, action, options = {})
        params = {
          :PROFILEID => profile_id,
          :ACTION => action
        }
        if options[:note]
          params[:NOTE] = options[:note]
        end
        response = self.request :ManageRecurringPaymentsProfileStatus, params
        new_response response
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
        if options[:max_amount]
          params[:MAXAMT] = Util.formatted_amount options[:max_amount]
        end
        response = self.request :CreateBillingAgreement, params
        new_response response
      end

      def agreement(reference_id)
        params = {
          :REFERENCEID => reference_id
        }
        response = self.request :BillAgreementUpdate, params
        new_response response
      end

      def charge!(reference_id, amount, options = {})
        params = {
          :REFERENCEID => reference_id,
          :AMT => Util.formatted_amount(amount),
          :PAYMENTACTION => options[:payment_action] || :Sale
        }
        if options[:currency_code]
          params[:CURRENCYCODE] = options[:currency_code]
        end
        response = self.request :DoReferenceTransaction, params
        new_response response
      end

      def revoke!(reference_id)
        params = {
          :REFERENCEID => reference_id,
          :BillingAgreementStatus => :Canceled
        }
        response = self.request :BillAgreementUpdate, params
        new_response response
      end


      # Refund Specific

      def refund!(transaction_id, options = {})
        params = {
          :TRANSACTIONID => transaction_id,
          :REFUNDTYPE => :Full
        }
        if options[:invoice_id]
          params[:INVOICEID] = options[:invoice_id]
        end
        if options[:type]
          params[:REFUNDTYPE] = options[:type]
          params[:AMT] = options[:amount]
          params[:CURRENCYCODE] = options[:currency_code]
        end
        if options[:note]
          params[:NOTE] = options[:note]
        end
        response = self.request :RefundTransaction, params
        new_response response
      end

      private

      def new_response response, options = {}
        Response.new response, options.merge(environment: environment)
      end

    end
  end
end
