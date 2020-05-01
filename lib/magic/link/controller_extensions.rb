module Magic
  module Link
    module ControllerExtensions
      def self.included(base)
        base.send(:include, InstanceMethods)
      end

      module InstanceMethods
        def authenticate_user_from_magic_link_token!
          token_param = params[:sign_in_token].presence
          email_param = params[:email].presence
        
          # Bail out early if these aren't set, otherwise we are checking this on every request
          return unless token_param && email_param

          resource  = Magic::Link.user_class.find_by(email: email_param)
          token = Token.find_by(token: Devise.token_generator.digest(Token, :token, token_param))

          if send("#{Magic::Link.user_class.name.underscore}_signed_in?")
            check_magic_link_redirect!
          elsif magic_link_token_matches?(resource, token)
            if !magic_link_token_expired?(token)
              token.destroy unless token.reusable?
              sign_in resource
              check_magic_link_redirect!
            else 
              flash[:alert] = "That link was expired, but we just sent you a new one. Please click that link to login."
              path_param = params[:path].presence
              redirect_id_param = params[:redirect_id].presence 
              new_magic_link = MagicLink.new(email: resource.email, path: path_param, redirect_id: redirect_id_param, reusable: token.reusable?)
              new_magic_link.send_login_instructions.deliver_now
              token.destroy
            end   
          else
            flash[:alert] = "Token or email invalid. Please sign in to access that page."
            redirect_to main_app.new_user_session_path
          end
        end

        def check_magic_link_redirect!
          path_param = params[:path].presence
          redirect_id_param = params[:redirect_id].presence

          return unless path_param

          redirect_to_magic_link_path(path_param, redirect_id_param)
        end 

        def redirect_to_magic_link_path(path, redirect_id)
          if path && redirect_id
            redirect_to send("#{path}_path".to_sym, redirect_id)
          elsif path
            redirect_to "#{path}".to_sym
          else
            redirect_to admin_dashboard_url
          end
        end

        def magic_link_token_matches?(resource, token)
          return false unless resource && token && (token.resource == resource) 

          Devise.secure_compare(
            token.token,
            Devise.token_generator.digest(Token, :token, params[:sign_in_token])
          )
        end

        def magic_link_token_expired?(token)
          token.token_sent_at <= Magic::Link.token_expiration_hours.hours.ago
        end
      end
    end
  end
end
