require 'mailcrate'
require 'port'
require 'matchers/eventually'

TEST_PORT = 8025

describe Mailcrate do

  before(:each) do
    @mailcrate = Mailcrate.new(TEST_PORT)
  end

  after(:each) do
    @mailcrate.stop
  end

  describe 'ports' do

    it 'should open a port' do
      @mailcrate.start

      port(TEST_PORT).should be_open
    end

    it 'should close a port' do
      @mailcrate.start
      @mailcrate.stop

      port(TEST_PORT).should_not be_open
    end

    it 'should not allow a second server to be started on the same port'
  end
  
  describe 'starting and stopping' do
      
    it 'should block when start is called until SMTP server is ready' do
      slow_server = SlowTCPServer.new('localhost', TEST_PORT)

      @mailcrate.start(:service => slow_server)

      socket = TCPSocket.open('localhost', TEST_PORT)
      welcome_message = socket.gets.chomp
      
      welcome_message.should == '220 localhost mailcrate ready ESTMP'
    end
      
  end

  describe 'should accept SMTP traffic' do

    it 'should recieve email' do
      @mailcrate.start

      socket = TCPSocket.open('localhost', TEST_PORT)
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

class SlowTCPServer < TCPServer
  def accept
    sleep(1)
    super
  end
end
