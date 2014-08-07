require "socket"
require "timeout"


class Ioport
  attr_accessor :timeout
  def initialize(ip,port)
    @ip=ip
    @port=port
    @timeout=2
    @server=open_server
    
  end
  
  def open_server()
    
    begin
      Timeout.timeout(@timeout+3) do
         return TCPSocket.new(@ip,@port)
      end
      
    rescue Timeout::Error 
      puts "#{info()} can't connect server"
      
    end
    
  end
  def info()
    "#Class:#{self.class}:#{self.object_id} :"
  end
  def send(cmd)

       @server.write(cmd)
 
   end
   
   def sendln(cmd)
     @server.write(cmd + "\n")
   end
   def gets()
     begin
       Timeout.timeout(@timeout) do
         return @server.gets
       end
     rescue Timeout::Error
       puts "#{info()} *** gets() Timeout %s" % timeout 
       raise Timeout::Error
      end 
     
    
   end
   def getc()
     begin
       Timeout.timeout(@timeout) do
         return @server.getc
       end
     rescue Timeout::Error
       puts "#{info()} getc() *** Timeout %s" % timeout 
    
       raise Timeout::Error
       
     end
     
    
   end
   

   def read()
     begin
       Timeout.timeout(@timeout) do
         return @server.gets
       end
     rescue Timeout::Error
       puts "#{info()} *** Timeout %s" % timeout 
       raise Timeout::Error

     end


   end
  
end