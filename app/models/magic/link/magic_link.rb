module Magic
  module Link
    class MagicLink
      attr_accessor :email, :user, :reusable

      def initialize(email:, reusable: false)
        @email = email
        @reusable = reusable
        @user = Magic::Link.user_class.find_by(email: email.downcase)
      end 

      def send_login_instructions
        token = get_login_token
        MagicLinkMailer.send_magic_link(email, token)
      end

      def get_login_token
        @token ||= generate_sign_in_token
      end

      def to_param 
        to_hash.to_param
      end
      
      def to_hash 
        {email: email, sign_in_token: get_login_token}
      end 

      private

        def generate_sign_in_token
          raw, enc = Devise.token_generator.generate(Token, :token)
          Token.create(resource_id: user.id, token: enc, token_sent_at: Time.current, reusable: reusable)
          raw
        end
    end
  end
end
