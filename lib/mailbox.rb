require 'socket'

class Mailbox
	def initialize(port)
		@port = port
	end


	def start
		@service = TCPServer.new('localhost', @port )
	end

	def stop
		@service.close unless @service.nil? || @service.closed? 
	end

end