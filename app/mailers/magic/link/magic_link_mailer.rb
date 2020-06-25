module Magic::Link
  class MagicLinkMailer < ApplicationMailer
    def send_magic_link(email, token, url: nil)
      @email = email
      @token = token
      if url 
        uri = URI url
        uri.query = CGI.parse(uri.query).merge({"email" => @email, "sign_in_token" => @token}).to_query
        @url = uri.to_s 
      end
      mail(to: email, subject: "Your sign in link")
    end
  end
end
