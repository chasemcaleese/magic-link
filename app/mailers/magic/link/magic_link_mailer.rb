module Magic::Link
  class MagicLinkMailer < ApplicationMailer
    def send_magic_link(email, token, path)
      @email = email
      @token = token
      @path = path
      mail(to: email, subject: "Your sign in link")
    end
  end
end
