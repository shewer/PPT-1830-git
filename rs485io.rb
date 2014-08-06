require "./ioport.rb"
require "thread"
require "./modbus_package.rb"
# Mobus under RS485 此物件 此餐理 8byte 字串 chacksum 及return 字串 
Modbus_Error_Code="\x22\x00\x00\x00\x00\x00\x00\x22"
class Rs485_IO < Ioport
  attr_accessor :remote_status
  def initialize(ip,port)
    super ip,port
    # Ioport:  @server  @ip @timeout ( for  getc gets timeout set)
    @remote_status=Queue.new
    @return_status=Queue.new
  end
  
 # rewrite  use thread 
      
  def write(str)
    # mod_package=   stri.is_a?(String) ? ModBus_Package.new(stri)  : stri
    # write_modbus(mod_package.to_s)
    raise "Rs485_IO stri: chk_chksum error " unless chk_chksum(str)
    send str
    ret_modbus()
    
  end

    

 



  # 增加 擁取  remote 的return 的信息 暫時取消 測試系統穩定剖
  def ret_modbus()  # return ModBus_Package object
    
    begin
      mod_package=ModBus_Package.new get_modbus()
      
      raise "remote controller input"  if mod_package.cmd == 0x61
      return mod_package
    rescue  # RunTimeError => e
      @remote_status.push mod_package  # if remote command  Push to remote buffer & retry read agian
      retry
    end
    
   
  end
  #str 暫時覺用字串  待修正為 modbus_package
  def send_modbus(str)
    
    send(str)
    ret_modbus()
  end
  
  def get_modbus()
    str=""
    begin
      Timeout.timeout(1) do
        
          if (head = @server.getc)== "\x22"
            str << head
            7.times {
              str << @server.getc
            }
            raise "get_modbus chk_chksum ERROR "  unless chk_chksum(str)
            return str
          end  # end if 
      end
    rescue RuntimeError
      puts "chesum error Retry (#{str})"
      @server.send("\x55\x01\x10\x00\x00\x00\x00\x66")
      retry 
    rescue Timeout::Error
       return Modbus_Error_Code
      
    end
    
  end
  
  
  def modify_chksum(stri)
    if stri.size==8
        str=stri.clone
        str[7] = 0.chr
      sum=0
      ar=str.bytes
      ar.each {|x| sum += x}
      sum %= 256
      str[7]= sum.chr
      return (str)
    end
  end
  
  def chk_chksum(str)
    str== modify_chksum(str)
  end
  

  
end