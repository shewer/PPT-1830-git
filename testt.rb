# def modbustest(hexstr)
#   a=hexstr.split 
#   if a.size==7
#     bin=""
#     chksum=0
#     a.each {|x|
#       byt=x.hex
#       bin << byt.chr
#       chksum  += byt }
#       chksum % 256
#       bin << (chksum % 256).chr 
#    end
#    return bin 
# end
# 
# def getmodbustest(server)
#   begin
#       Timeout.timeout(2)
#          loop{ 
#            if server.getc=="\22"
#                a=[]
#               7.times { a.push server.getc}
#            end
#          }
#            
#            
#          
#          
#          
#   rescue Timeout::Error
#      puts "END"
#    end
#    
#   return a
#   
# end
# 
# 
# server.write modbustest "55 01 12 00 00 ff ff"
# 
# 
# 
# require './test_proc.rb'
# require './rs485io.rb'
# require './testunit.rb'
# require './ppt1830.rb'
# requier './ioboard88.rb'
# tproc=[[3.59, false], [3.63, true], [3.53, true], [3.5, false]]
# gpib=Gpib.new("192.168.3.221",1234)
# rs485=Rs485_IO.new("192.168.3.231",6000)
# ppt1830=PPT_1830.new(gpib,7)
# ioboard=Ioboard88.new(rs485,1)
# 
# u1=TestUnit.new(:T1,4,ioboard,ppt1830)
# tp=TestProc.new(ppt1830)
# tp.add_proc(tproc)
# 
# 
# require './controller.rb'
# require './test_proc.rb'
 require './rs485io.rb'
 require './testunit.rb'
 require './ppt1830.rb'
# require './ioboard88.rb'
# tproc=[[3.59, false], [3.63, true], [3.53, true], [3.5, false]]
# a=Controller.new
# a.add_test_proc tproc
# a.init_unit
# 


require "./ioboard88.rb"

IO_SERVER="192.168.3.231"
IO_PORT=6000
GPIB_SERVER="192.168.3.221"
GPIB_PORT=1234

rs485=Rs485_IO.new(IO_SERVER,IO_PORT)
iob=Ioboard88.new(rs485,1)

iob.delay_on(1,500)
p rs485

def test(iob,rs485,time)
(1..65000).each {|x| ret=iob.relay_set_byte x%256  ;sleep time ;      p ret.data
   cmd=remote_cmd rs485
   if cmd >0
     
     time /= 2.00 if cmd==1 
	 time *= 2.00 if cmd==2 
	 time = cmd *0.1 if cmd >2 
     p time
     throw :exit if  cmd== 15
   end
   }
end

def remote_cmd(rs485)
	return 0 if rs485.remote_status.size==0
    remote_ret=rs485.remote_status.pop 
     p remote_ret.data

     p cmd= remote_ret.data.unpack("C4")[0]
end
loop {
sleep 0.1
iob.get_io_status()

tt=remote_cmd(rs485)
p tt
catch(:exit) { test iob,rs485 , tt* 0.1 }   if tt > 00



}


# loop {
#   s=false
#   (1..8).each {|x| 
#     iob.delay_on(x,0.3) 
#     sleep 0.4; 
#     if rs485.remote_status.size >0
#       s=rs485.remote_status.shift.unpack("C8")[3]== 15
#     end
#     p s
#     break  if s 
#     }
#     break if s
# }

