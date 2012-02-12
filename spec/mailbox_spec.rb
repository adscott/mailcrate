require 'mailbox'
require 'port'

describe Mailbox do

	before do
		@mailbox = Mailbox.new(2525)
	end

	after do
		@mailbox.stop
	end

	describe 'ports' do

		it 'should open a port' do
			@mailbox.start

			port(2525).should be_open
		end

		it 'should close a port' do
			@mailbox.start
			@mailbox.stop

			port(2525).should_not be_open
	  end

	  it 'should not allow a second server to be started on the same port'

    def port(port)
		  Port.new(port)
		end
  end

  describe 'should accept SMTP traffic' do

  	it 'should recieve email' do
  		@mailbox.start

  		socket = TCPSocket.open('localhost', 2525)
			socket.puts('helo localhost.localdomain')
			socket.puts('MAIL FROM:myaddress@mydomain.com')
			socket.puts('RCPT TO:somone@somedomain.com')
			socket.puts('DATA')
			socket.puts('Hello Fred, can you call me?')
			socket.puts('.')
			socket.puts('QUIT')

			while(@mailbox.mails.empty?) do
				sleep(0.1)
			end

			@mailbox.mails[0][:from].should == 'myaddress@mydomain.com'
  	end

  end
	
end