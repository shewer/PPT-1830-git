require "./ioport.rb"


Modbus_Error_Code="\x22\x00\x00\x00\x00\x00\x00\x22"
class Rs485_IO < Ioport
  attr_accessor :remote_status
  def initialize(ip,port)
    super ip,port
    @remote_status=[]
  end
  
 # rewrite  use thread 
      
  def write(stri,ret=true,timeout=2)
    return 1 if stri.size != 8
    #str= "\x55" + stri + "\x00"
    
    str=add_chksum(stri)
 #  puts "chk sum :" + str
    @server.write(str)
    # rt_str=@ret_str
    #    @ret_str=nil
    #       
    rt_str=read_modbus()
    return rt_str
  end

    

  def write_modbus(str)
    @server.write(str)
  end
  # 增加 擁取  remote 的return 的信息 暫時取消 測試系統穩定剖
  def read()
    str=""
    begin
      str=read_modbus()
      raise "remote controller input"  if str[2]== 0x61.chr
      return str
    rescue  # RunTimeError => e
      @remote_status.push str
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