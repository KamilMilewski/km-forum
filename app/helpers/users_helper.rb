# :nodoc:
module UsersHelper
  def avatar_url(user)
    user.avatar? ? user.avatar.url : gravatar_url(user)
  end

  def gravatar_url(user)
    email_digest = Digest::MD5.hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{email_digest}?d=identicon"
  end
end
