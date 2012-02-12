require 'action_mailer'

class Mailer < ActionMailer::Base
  default :from => 'from@example.com'

  def welcome_email(email)
    mail(:to => email, :subject => 'Welcome to My Awesome Site', :body => 'Full of awesomeness.')
  end
end
