module TidasBackend
  class App
    module SessionsHelper
      def authorize!
        validate_warden_authentication
        validate_account_status
      end

      def validate_warden_authentication
        env['warden'].raw_session["referrer"] = request.path
        unless authenticated?
          redirect_to url_for(:sessions,:login)
        end
      end

      def validate_account_status
        # check confirmed email
      end
    end

    helpers SessionsHelper
  end
end
