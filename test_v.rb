require './ppt1830.rb'
require './rs485io.rb'


gpib=Gpib.new("192.168.3.221",1234)
rs485=Rs485_IO.new("192.168.3.231",6000)
ppt1830=PPT_1830.new(gpib,7)
ioboard=Ioboard88.new(rs485,1)



def tt(ioboard)
[:T1,:T2,:T3,:T4].each {|t|  
  ioboard.reset_ch()
  [:C1,:C2,:C3,:C4].each {|c|
      
       sleep 1
      p ioboard.relay_set(t,c) 
    
  }
      sleep 1
      
  }
  ioboard.reset_ch
  
end