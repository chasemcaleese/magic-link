module Magic::Link
  class MagicLinkMailer < ApplicationMailer
    def send_magic_link(email, token, path, redirect_id)
      @email = email
      @token = token
      @path = path
      @redirect_id = redirect_id
      mail(to: email, subject: "Your sign in link")
    end
  end
end
