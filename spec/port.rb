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
  
