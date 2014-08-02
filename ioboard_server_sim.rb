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
          
        begin
          Timeout.timeout(2) do
            str=""
            chr=client.getc
            if chr== "\x55"
              str << "\x55"
              7.times {
                str << client.getc
              }
            end
        rescue Timeout::Error 
          next          
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