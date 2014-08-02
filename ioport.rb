require "socket"
require "timeout"


class Ioport
  def initialize(ip,port)
    @ip=ip
    @port=port
    @server=open_server
    
  end
  
  def open_server()
    
    begin
      Timeout.timeout(5) do
         return TCPSocket.new(@ip,@port)
      end
      
    rescue Timeout::Error 
      puts "can't connect server"
      
    end
    
  end
  def write(cmd,ret=false,timeout=2)

       @server.write(cmd + "\n")
       return read().chomp if ret 

   end

   def read(timeout=2)
     begin
       Timeout.timeout(timeout) do
         return @server.gets
       end
     rescue Timeout::Error
       puts "*** Timeout %s" % timeout 

     end


   end
  
end