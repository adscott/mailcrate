require 'examples/app/mailer'
require 'lib/mailcrate'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
 :address   => 'localhost',
 :port      => 2525
}


describe Mailer do

  before do
    @mailcrate = Mailcrate.new(2525)
    @mailcrate.start
  end

  after do
    @mailcrate.stop
  end

  it 'should use Mailcrate to send mails' do
    mail = Mailer.welcome_email('a@b.com')
    mail.deliver

    @mailcrate.mails[0][:from].should == '<from@example.com>'
    @mailcrate.mails[0][:to_list].should include '<a@b.com>'
    @mailcrate.mails[0][:body].should include 'Full of awesomeness.'
  end

end
