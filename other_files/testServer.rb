require 'socket' 

server = TCPServer.open(21136)
puts 'test server start up!! -- Ctrl + c to stop'
loop {
  Thread.start(server.accept) do |client|
		puts client.gets
    # client.puts "回复"	
    client.close
  end
}