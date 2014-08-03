require "./ioport.rb"
require "thread"
require "./modbus_package.rb"

Modbus_Error_Code="\x22\x00\x00\x00\x00\x00\x00\x22"
class Rs485_IO < Ioport
  attr_accessor :remote_status
  def initialize(ip,port)
    super ip,port
    @remote_status=Queue.new
    @return_status=Queue.new
  end
  
 # rewrite  use thread 
      
  def write(stri,ret=true,timeout=2)
    # return 1 if stri.size != 8
    #str= "\x55" + stri + "\x00"  
    mod_package=   stri.is_a?(String) ? ModBus_Package.new(stri)  : stri
   
    
    # str=add_chksum(stri)
 #  puts "chk sum :" + str
    write_modbus(mod_package.to_s)
    # rt_str=@ret_str
    #    @ret_str=nil
    #       
    read()
    
  end

    

  def write_modbus(str)
    @server.write(str)
  end



  # 增加 擁取  remote 的return 的信息 暫時取消 測試系統穩定剖
  def read()  # return ModBus_Package object
    
    begin
      mod_package=ModBus_Package.new read_modbus()
      
      raise "remote controller input"  if mod_package.cmd == 0x61
      return mod_package
    rescue  # RunTimeError => e
      @remote_status.push mod_package  # if remote command  Push to remote buffer & retry read agian
      retry
    end
    
   
  end
  
  
  def read_modbus()
    str=""
    begin
      Timeout.timeout(1) do
        
          if (head = @server.getc)== "\x22"
            str << head
            7.times {
              str << @server.getc
            }
            return str
          end  # end if 
      end

    rescue Timeout::Error
       return Modbus_Error_Code
      
    end
    
  end
  
  
  def add_chksum(stri)
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
  
  def chk_chksum(stri)
    stri== add_chksum(stri)
  end
  

  
end