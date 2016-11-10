# :nodoc:
class ApplicationMailer < ActionMailer::Base
  default from: 'km.web.smtp@gmail.com'
  layout 'mailer'
end
