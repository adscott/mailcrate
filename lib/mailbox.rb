class Mailbox
	def initialize(port)
		@port = port
	end


	def start
		@service = TCPServer.new('localhost', @port )
	end

end