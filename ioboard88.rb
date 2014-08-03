require "./rs485io.rb"
MOD_HEAD=0x55

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
    
    io_status= relay_set_byte( output_chk(ti,ci) )
    # puts io_status
    @io_status=  io_status #io_status.size==8 ? io_status : nil
  end
  
  

  def relay_set_byte(relay_set_output)
    begin
          relay_set_output %= 256
          sa=[0x55,@addr,0x13,00,00,00,relay_set_output,0] # set :C0 :T0
          return  @server.write(sa.pack("C8"))

    rescue Exception
          puts "relay_set(byte) error "
          return get_io_status()
      
    end
    
  end
  def output_chk(ti=:T0,ci=:C0)
    return nil if  ci.class!=Symbol || ti.class !=Symbol
    #puts @sel_test_ch[ci]
    #puts @sel_test_board[ti]
    return @sel_test_ch[ci] | @sel_test_board[ti]
  end
  def get_io_status()
    sa=[0x55,@addr,0x10,0,0,0,0,0]
    io_status=@server.write(sa.pack("C8"))
    puts io_status
    @io_status =  io_status# debug.size==8 ? io_status : nil
  end
  
  
  def delay_time(ms)
    return "\x00\x00\x00"  if ms > 1677216 || ms <0
    return [ms].pack("L").reverse[1,3]
  end
  
  def delay_on(bit,ms)
    sa=[MOD_HEAD,@addr,0x22,delay_time(ms),bit,0]
 # p sa.pack("C3a3C2")
    io_status=@server.write(sa.pack("C3A3C2") )   
    
    begin
      @io_status=  io_status.size==8 ? io_status : nil
    rescue NoMethodError
      @io_status = nil
    end 
  end
  
  def delay_off(bit,ms)
    sa=[MOD_HEAD,@addr,0x21,delay_time(ms),bit,0]
    p sa.pack("C3a3C2")
    io_status=@server.write(sa.pack("C3A3C2")  )  
    @io_status=  io_status.size==8 ? io_status : nil
  
  end
  
  
  def relay_on(byte)
    
  end
  def relay_off(byte)
    
  end
  
end