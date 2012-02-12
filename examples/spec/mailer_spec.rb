require 'examples/app/mailer'
require 'lib/mailbox'

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
 :address   => 'localhost',
 :port      => 2525
}


describe Mailer do

	before do
		@mailbox = Mailbox.new(2525)
		@mailbox.start
	end

	after do
		@mailbox.stop
	end

	it 'should use Mailbox to send mails' do
		mail = Mailer.welcome_email('a@b.com')
		mail.deliver

		@mailbox.mails[0][:from].should == '<from@example.com>'
		@mailbox.mails[0][:to_list].should include '<a@b.com>'
		@mailbox.mails[0][:body].should include 'Full of awesomeness.'
	end

end