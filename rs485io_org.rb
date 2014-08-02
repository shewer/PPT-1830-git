require "./ioport.rb"

class Rs485_IO < Ioport
  attr_accessor :remote_status
  def initialize(ip,port)
    super ip,port
    @remote_status=[]
  end
  
 
      
  def write(stri,ret=true,timeout=2)
    return 1 if stri.size != 8
    #str= "\x55" + stri + "\x00"
    
    str=add_chksum(stri)
   # puts "chk sum :" + str
    @server.write(str)
    return read() if ret
  end

    

  def write_modbus(str)
    @server.write(str)
  end
  
  def read()
    str=""
    loop  { 
       str=read_modbus()
       break if str[2]!= 0x61.chr
       @remote_status.push str

    }    
    
    str.size == 8 ? str : nil
    @ret_str=str    
  end
  
  
  def read_modbus()
    str=""
    begin
      Timeout.timeout(1) do
        loop {
          if (head = @server.getc)== "\x22"
            str << head
            7.times {
              str << @server.getc
            }
            return str
          end  # end if 
          }
      end
        
    rescue Timeout::Error
       return str
      
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