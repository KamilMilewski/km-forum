module UsersHelper
  def gravatar_url user
    email_digest = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{email_digest}"
  end
end
