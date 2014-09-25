require './examples/app/mailer'
require './lib/mailcrate'

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

    expect(@mailcrate.mails[0][:from]).to eq '<from@example.com>'
    expect(@mailcrate.mails[0][:to_list]).to include '<a@b.com>'
    expect(@mailcrate.mails[0][:body]).to include 'Full of awesomeness.'
  end

end
