
# class ModBus_Package 處理 modbus 封包的資料 及 相驚變數 addr / cmd/ data 
#   最後一樣 chksum 將由此物件處理
   


HEAD_CODE={:send=> 0x55,:return=>0x22}
HEAD_CODEtoSym={0x55=>:send,0x22=>:retur}
class ModBus_Package
  attr_reader :mode ,:addr,:cmd,:data
  # def str_init(str)
  #    ar.
  #    raise  "Modbus init str chacksum error " if  !get_chksum(str)
  #    
  #    
  #  end
  def initialize(addr=0,cmd=0,data_4byte="\x00\x00\x00\x00",mode=:send)
    begin
      raise "addr type Error" if addr.is_a? String
      @mode=mode
      @addr=addr
      @cmd=cmd
      @data=data_4byte

    rescue 
      @mode,@addr,@cmd,@data=self.unpack(addr)
      
    end
  
    
  end
  def unpack(str,chk_sum=true)
    raise "String Size ERROR" unless str.size==8
    
    ar=str.unpack("C3a4C")
     ar[0] = (ar[0]== 0x55) ? :send : :return
    sum=ar.pop
    if chk_sum && ar[0]==:return
      raise "String checksum error" unless  chk_chksum(str[0,7],sum)
    end
    return ar
  end
  
    def pack()
    [HEAD_CODE[@mode],@addr,@cmd,@data,chksum()].pack("C3a4C")
  end    
  def to_s()
      pack()
  end
  
  
  def get_chksum(str) #  caulateor all string 
      sum=0
      ar=str.bytes.each {|x| sum += x}
      sum %= 256
  end
  def chksum()  # array to 7Bytes string
    sum=get_chksum(
        [HEAD_CODE[@mode],@addr,@cmd,@data].pack("C3a4") )
  end
  
  
  

  
  def chk_chksum(stri,sum) # for 8 bytes  str[0,7], str[7] 
    sum == get_chksum(stri)
  end
  
  
  
end