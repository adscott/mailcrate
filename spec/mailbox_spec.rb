require 'mailbox'

describe Mailbox do

	it 'should open a port' do
		mailbox = Mailbox.new(2525)
		mailbox.start

		port(2525).should be_open
	end

  require 'socket'
  require 'timeout'

	class Port
		def initialize(port)
			@port = port
		end

		def open?
		  begin
		    Timeout::timeout(1) do
		      begin
		        s = TCPSocket.new('localhost', @port)
		        s.close
		        return true
		      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
		        return false
		      end
		    end
		  rescue Timeout::Error
		  end

		  return false
	  end
	end

	def port(port)
	  Port.new(port)
	end
	
end