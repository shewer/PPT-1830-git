require "socket"
require "timeout"

class GpibServerSim
  def initialize(port)
    @port=port
    @server=nil
    @addr=nil
    self.run
  end
  def run
    @server=TCPServer.open(@port)
    loop {
      Thread.start(@server.accept) do |client|
        loop {
        p client
        puts ss=client.gets.chomp
        return_str=self.command(ss)
        client.puts return_str if return_str != nil 
        #client.puts(Time.now.ctime)
        
        
         if ss== "quit" 
           client.close
           #client.puts "Closeing the connection. Bye!"
         end
      }
      end
    }
  end
#  def command(str)
#    
#    "server:" + str
#  end
  def command(str)
      ar=str.split(/ /)
      case ar[0]
      when "++addr"
        if ar.size<2
          return @addr.to_s
        else 
          @addr=ar[1].to_i
        end

      end
      return nil
  end
end