module Magic
  module Link
    module ControllerExtensions
      def self.included(base)
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def authenticate_user_from_token!
          email = params[:email].presence
          token = params[:sign_in_token].presence
          route = params[:to].presence

          user  = email && token && Magic::Link.user_class.find_by(email: email)

          if token && send("#{Magic::Link.user_class.name.underscore}_signed_in?")
            #flash.now[:alert] = "You are already signed in"
          elsif user && token_matches?(user) && !token_expired?(user)
            #flash[:notice] = "You have signed in successfully"
            user.update_columns(sign_in_token: nil, sign_in_token_sent_at: nil)
            sign_in user
            if route
              redirect_to "#{route}".to_sym
            else
              redirect_to admin_dashboard_url
            end
          elsif user && token_matches?(user) && token_expired?(user)
            flash[:alert] = "That link has expired, but we just sent you a new one."
            user.update_columns(sign_in_token: nil, sign_in_token_sent_at: nil)
            new_magic_link = MagicLink.new(email: email)
            new_magic_link.send_login_instructions
          elsif email && token
            flash[:alert] = "Your sign in token is invalid"
            redirect_to main_app.root_path
          end
        end

        def token_matches?(user)
          Devise.secure_compare(
            user.sign_in_token,
            Devise.token_generator.digest(Magic::Link.user_class, :sign_in_token, params[:sign_in_token])
          )
        end

        def token_expired?(user)
          user.sign_in_token_sent_at <= Magic::Link.token_expiration_hours.hours.ago
        end
      end
    end
  end
end
