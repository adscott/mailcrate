require 'mailbox'
require 'port'

describe Mailbox do

	before do
		@mailbox = Mailbox.new(2525)
	end

	after do
		@mailbox.stop
	end

	it 'should open a port' do
		@mailbox.start

		port(2525).should be_open
	end

	it 'should close a port' do
		@mailbox.start
		@mailbox.stop

		port(2525).should_not be_open
  end

  def port(port)
	  Port.new(port)
	end
	
end