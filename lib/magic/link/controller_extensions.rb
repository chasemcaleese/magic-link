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
          path = params[:path].presence

          user  = email && token && Magic::Link.user_class.find_by(email: email)

          if token && send("#{Magic::Link.user_class.name.underscore}_signed_in?")
            redirect_to_path(path)
            #flash.now[:alert] = "You are already signed in"
          elsif user && token_matches?(user) && !token_expired?(user)
            #flash[:notice] = "You have signed in successfully"
            user.update_columns(sign_in_token: nil, sign_in_token_sent_at: nil)
            sign_in user
            redirect_to_path(path)
          elsif user && token_matches?(user) && token_expired?(user)
            flash[:alert] = "That link has expired, but we just sent you a new one."
            user.update_columns(sign_in_token: nil, sign_in_token_sent_at: nil)
            new_magic_link = MagicLink.new(email: email, path: path)
            new_magic_link.send_login_instructions
          elsif email && token
            flash[:alert] = "Your sign in token is invalid"
            redirect_to main_app.root_path
          end
        end

        def redirect_to_path(path)
          if path
            redirect_to "#{path}".to_sym
          else
            redirect_to admin_dashboard_url
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
