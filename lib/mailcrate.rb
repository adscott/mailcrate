require 'socket'

class Mailcrate

  def self.used_ports
    @used_ports ||= []
  end

  attr_reader :mails, :port

  def initialize(port)
    @port = port
    @mails = []
  end

  def start(opts = {})
    raise Errno::EADDRINUSE if self.class.used_ports.include?(@port)
    self.class.used_ports << @port
    @service = opts[:service] || TCPServer.new('localhost', @port)
    @thread = Thread.new { accept(@service) }
  end

  def stop
    self.class.used_ports.delete(@port)
    @thread.kill unless @thread.nil?
    @thread.join unless @thread.nil?
    @service.close unless @service.nil? || @service.closed?
  end

  private

  def accept(service)
    while session = service.accept
      class << session
        def get_line
          line = gets
          line.chomp! unless line.nil?
          line
        end
      end

      begin
        serve(session)
      rescue Exception => e
        puts e.message
      end
    end
  end

  def serve(connection)
    connection.puts("220 localhost mailcrate ready ESTMP")
    helo = connection.get_line

    if helo =~ /^EHLO\s+/
      connection.puts "250-localhost mailcrate here"
      connection.puts "250 HELP"
    end

    from = connection.get_line
    connection.puts("250 ok")

    to_list = []

    loop do
      to = connection.get_line
      break if to.nil?

      if to =~ /^DATA/
        connection.puts( "354 start" )
        break
      else
        to_list << to
        connection.puts( "250 ok" )
      end
    end

    lines = []
    loop do
      line = connection.get_line
      break if line.nil? || line == "."
      lines << line
    end

    connection.puts "250 ok"
    connection.gets
    connection.puts "221 bye"

    @mails << {
      :from => from.gsub(/MAIL FROM:\s*/, ''),
      :to_list => to_list.map { |to| to.gsub( /RCPT TO:\s*/, "" ) },
      :body => lines.join( "\n" )
    }

    connection.close
  end

end
