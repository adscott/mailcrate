require 'mailbox'
require 'port'

describe Mailbox do

	it 'should open a port' do
		mailbox = Mailbox.new(2525)
		mailbox.start

		port(2525).should be_open
	end

  def port(port)
	  Port.new(port)
	end
	
end