require "socket"
require "timeout"


class Ioport
  attr_accessor :timeout
  def initialize(ip,port)
    @ip=ip
    @port=port
    @server=open_server
    @timeout=2
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
  def send(cmd)
    @server.send(cmd)
  end
  
  def gets()
    begin
      Timeout.timeout(@timeout) do
        return @server.gets
      end
    rescue Timeout::Error
      puts "*** Timeout %s" % timeout 

    end
  end

  def getc()
    begin
      Timeout.timeout(@timeout) do
        return @server.getc
      end
    rescue Timeout::Error
      puts "*** Timeout %s" % timeout 

    end
    
  end
    
    
  # def write(cmd,ret=false,timeout=2)
  # 
  #      @server.write(cmd + "\n")
  #      return read().chomp if ret 
  # 
  #  end

   def read()
     begin
       Timeout.timeout(@timeout) do
         return @server.gets
       end
     rescue Timeout::Error
       puts "*** Timeout %s" % timeout 

     end


   end
  
end