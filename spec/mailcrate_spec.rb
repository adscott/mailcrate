require 'mailcrate'
require 'port'
require 'rspec/collection_matchers'
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

      expect(port(TEST_PORT)).to be_open
    end

    it 'should close a port' do
      @mailcrate.start
      @mailcrate.stop

      expect(port(TEST_PORT)).to_not be_open
    end

    it 'should not allow a second server to be started on the same port'
  end

  describe 'starting and stopping' do

    it 'should block when start is called until SMTP server is ready' do
      slow_server = SlowTCPServer.new('localhost', TEST_PORT)

      @mailcrate.start(:service => slow_server)

      socket = TCPSocket.open('localhost', TEST_PORT)
      welcome_message = socket.gets.chomp

      expect(welcome_message).to eq '220 localhost mailcrate ready ESTMP'
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

      expect(@mailcrate.mails).to eventually have(1).items
      expect(@mailcrate.mails[0][:from]).to eq 'myaddress@mydomain.com'
      expect(@mailcrate.mails[0][:to_list]).to include 'somone@somedomain.com'
      expect(@mailcrate.mails[0][:body]).to eq 'Hello Fred, can you call me?'
    end

  end

end

class SlowTCPServer < TCPServer
  def accept
    sleep(1)
    super
  end
end
