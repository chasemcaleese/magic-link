module Magic
  module Link
    class MagicLink
      attr_accessor :email, :user, :path, :redirect_id

      def initialize(email:, path: nil, redirect_id: nil)
        @email = email
        @user = Magic::Link.user_class.find_by(email: email.downcase)
      end 

      def send_login_instructions
        token = get_login_token
        MagicLinkMailer.send_magic_link(email, token, path, redirect_id)
      end

      def get_login_token
        @token ||= generate_sign_in_token
      end

      private

        def generate_sign_in_token
          raw, enc = Devise.token_generator.generate(Magic::Link.user_class, :sign_in_token)
          Token.create(resource_id: user.id, token: enc, token_sent_at: Time.current)
          raw
        end
    end
  end
end
