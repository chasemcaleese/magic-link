module Magic
  module Link
    class Utility
      
      def self.move_to_multi
        Magic::Link.user_class.where.not(:sign_in_token => nil ).each do |u|
          Magic::Link::Token.create!(resource_id: u.id, token: u.sign_in_token, token_sent_at: u.sign_in_token_sent_at)
        end 
      end     
    
    end 
  end 
end 