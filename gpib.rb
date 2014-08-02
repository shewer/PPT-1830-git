
require "./ioport.rb"


class Gpib < Ioport
  attr_reader :mode,:addr,:timeout
  def initialize(ip,port)
    super ip,port
    @mode=nil
    @addr=nil
    @timeout=nil
    read_init_volue()
    
  end
  def read_init_volue
    @mode   =  write("++mode",true).to_i==1 ? :Controller : :Device
    @addr=write("++addr",true).to_i
    @timeout=write("++read_tmo_ms",true).to_i  
  end
  
  # gpib  write command 
 
       #  
       # def mode()
       #   @mode
       # end
  
  def mode=(mode)
    
      write("++mode 1" ) if mode==:Device 
      write("++mode 0" ) if mode==:Controller
      @mode   =  write("++mode",true).to_i==1 ? :Controller : :Device
  end
  
  # def addr()
  #     @addr
  #   end
  
  def addr=(addr)
    write("++addr " + addr.to_s)
    @addr=write("++addr",true).to_i
  end

  def addr() ; @addr ;end
  def addr=(addr) ; set_addr(addr)  ; end
  
  
  
  # def timeout()
  #     
  #     @timeout
  #   end
  #   
  def timeout=(ms)
    write("++read_tmo_ms " + ms.to_s)
    @timeout=write("++read_tmo_ms",true).to_i  
  end

  
end