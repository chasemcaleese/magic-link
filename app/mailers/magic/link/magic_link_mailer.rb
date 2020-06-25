module Magic::Link
  class MagicLinkMailer < ApplicationMailer
    def send_magic_link(email, token, url: nil, params: [])
      @email = email
      @token = token
      @url = url 
      @params = params
      mail(to: email, subject: "Your sign in link")
    end
  end
end
