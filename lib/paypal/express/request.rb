module Paypal
  module Express
    class Request < NVP::Request
      attr_required :return_url, :cancel_url

      def setup(payment_requests, options = {})
        params = {
          :RETURNURL => self.return_url,
          :CANCELURL => self.cancel_url
        }
        if options[:no_shipping]
          params[:REQCONFIRMSHIPPING] = 0
          params[:NOSHIPPING] = 1
        end
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

      def checkout!(token, payer_id, payment_requests)
        params = {
          :TOKEN => token,
          :PAYERID => payer_id
        }
        Array(payment_requests).each_with_index do |payment_request, index|
          params.merge! payment_request.to_params(index)
        end
        response = self.request :DoExpressCheckoutPayment, params
        Response.new response
      end

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

      def renew!(profile_id, action, note = '')
        params = {
          :PROFILEID => profile_id,
          :ACTION => action,
          :NOTE => note
        }
        response = self.request :ManageRecurringPaymentsProfileStatus, params
        Response.new response
      end

    end
  end
end