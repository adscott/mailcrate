require 'mailcrate'
require 'port'
require 'matchers/eventually'

describe Mailcrate do

	before do
		@mailcrate = Mailcrate.new(2525)
	end

	after do
		@mailcrate.stop
	end

	describe 'ports' do

		it 'should open a port' do
			@mailcrate.start

			port(2525).should be_open
		end

		it 'should close a port' do
			@mailcrate.start
			@mailcrate.stop

			port(2525).should_not be_open
	  end

	  it 'should not allow a second server to be started on the same port'
  end

  describe 'should accept SMTP traffic' do

  	it 'should recieve email' do
  		@mailcrate.start

  		socket = TCPSocket.open('localhost', 2525)
			socket.puts('helo localhost.localdomain')
			socket.puts('MAIL FROM:myaddress@mydomain.com')
			socket.puts('RCPT TO:somone@somedomain.com')
			socket.puts('DATA')
			socket.puts('Hello Fred, can you call me?')
			socket.puts('.')
			socket.puts('QUIT')

			@mailcrate.mails.should eventually have(1).items
			@mailcrate.mails[0][:from].should == 'myaddress@mydomain.com'
			@mailcrate.mails[0][:to_list].should include 'somone@somedomain.com'
			@mailcrate.mails[0][:body].should == 'Hello Fred, can you call me?'
  	end

  end
	
end
