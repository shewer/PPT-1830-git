require "./rs485io.rb"
require "./modbus_package.rb"
MOD_HEAD=0x55
SET_RELAY=0x13
GET_STATUS=0x10
DELAY_ON=0x22
DELAY_OFF=0x21
BIT_ON=0x12
BIT_OFF=0x11
class Ioboard88 
  def initialize(server,addr)
    @server=server
    @addr=addr
    @sel_test_board ={:T0=>0x00,:T1=>0x10,:T2=>0x20,:T3=>0x40,:T4=>0x80}
    @sel_test_ch ={:C0=>0x0f ,:C1=>0x0e ,:C2=>0x0d,:C3=>0x0b ,:C4=>0x07}
    @io_status=get_io_status()
    
    
  end
  
  def reset()
     relay_set() # default C0 T0
     
  end
  def relay_set(ti=:T0,ci=:C0)
    
    
    # puts io_status
    byte=set_output_byte(ti,ci)
    relay_set_byte( byte ) # return ModBus_Package
    #io_status #io_status.size==8 ? io_status : nil
  end
  
  def set_output_byte(ti=:T0,ci=:C0)
    return nil if  ci.class!=Symbol || ti.class !=Symbol
    return @sel_test_ch[ci] | @sel_test_board[ti]
  end 
  

  def relay_set_byte(output_byte)
    begin
          
          output_byte %= 256
          data= [0,0,0,output_byte].pack("C4")
          send(data,SET_RELAY)
          # sp=ModBus_Package.new(@addr,SET_RELAY,data) # set :C0 :T0
          # return  @server.write(sp)

    rescue Exception
          puts "relay_set(byte) error "
          return get_io_status()
      
    end
    
  end
  def send(data,cmd)
    sa=ModBus_Package.new(@addr,cmd,data)
    @io_status=@server.write(sa)
  end
  
  def get_io_status()
    data=[0,0,0,0].pack("C4")
    send(data,GET_STATUS)

  end
  
  
  def delay_time(ms)
    return "\x00\x00\x00"  if ms > 1677216 || ms <0
    return [ms].pack("L").reverse[1,3]
  end
  
  def delay_on(bit,ms)
    data=  delay_time(ms) + (bit%17).chr   # 0 off:  bit 1~16
    send(data,DELAY_ON)
    # sa=ModBus_Package.new(@addr,DELAY_ON,data)
    # @io_status=@server.write(sa)   
    
    # begin
    #   @io_status=  io_status.size==8 ? io_status : nil
    # rescue NoMethodError
    #   @io_status = nil
    # end 
  end
  
  def delay_off(bit,ms)
    # sa=[MOD_HEAD,@addr,0x21,delay_time(ms),bit,0]
    #  p sa.pack("C3a3C2")
    #  io_status=@server.write(sa.pack("C3A3C2")  )  
    #  @io_status=  io_status.size==8 ? io_status : nil
    #  
    data=  delay_time(ms) + (bit%17).chr   # 0 off:  bit 1~16
    send(data,DELAY_OFF)
    # sa=ModBus_Package.new(@addr,DELAY_OFF,data)
    # @io_status=@server.write(sa)   
  
  end
  
  
  def relay_on(bit)
    data="\x00\x00\x00" + (bit%17).chr
    send(data,BIT_ON)
    # sa=ModBus_Package.new(@addr,BIT_ON,data)
    # @io_status=@server.write(sa)   
    
  end
  def relay_off(bit)
    data="\x00\x00\x00" + (bit%17).chr
    send(data,BIT_OFF)
    # sa=ModBus_Package.new(@addr,BIT_OFF,data)
    # @io_status=@server.write(sa)   
    
    
  end
  
end