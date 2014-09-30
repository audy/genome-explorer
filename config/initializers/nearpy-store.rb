require 'socket'
require 'json'

class ProteinStore

  attr_accessor :hostname, :port, :socket

  def initialize args = {}
    @hostname = args[:hostname] || '127.0.0.1'
    @port = args[:port] || 1234
    connect!
  end

  def connect!
    @socket = TCPSocket.open(@hostname, @port)
  end

  def query sequence
    socket.puts "GET #{sequence}"
    JSON.parse(socket.gets)
  end

  def add sequence, id
    socket.puts "SET #{sequence} #{id}"
  end

end
