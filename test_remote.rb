require "./ioboard88.rb"

IO_SERVER="192.168.3.231"
IO_PORT=6000
GPIB_SERVER="192.168.3.221"
GPIB_PORT=1234

rs485=Rs485_IO.new(IO_SERVER,IO_PORT)
iob=Ioboard88.new(rs485,1)

class TestRemote
  def initialize(ioboard,rs)
    @ioboard=ioboard
    @rs485=rs
    @status=:Stop
  end
  def run
    loop {
  
     sleep 0.2
     old_status=@status
     set_status
     p @status  if old_status != @status
   }
      
  end
  
  
  
  

  def get_remote()
    @rs485.read
    if @rs485.remote_status.size >0
      s=@rs485.remote_status.shift.unpack("C8")[3]
      rbutton = case s
        when 1
          :RB1
        when 2
          :RB2
        when 3
          :RB3
        when 15
          :RB15
        else 
          :RB0
        end
      end
      return rbutton
    end
  
  def set_status()
    get_remote
      case c=get_remote
      when :RB1
        @status=:Start
      when :RB15
        @status=:Stop
      else @status= c
      end
  end


end
=begin
def test
  loop {
  s=false
  (1..8).each {|x| 
    iob.delay_on(x,300) 
    sleep 0.4; 
    set_status()      
    end
    p s
    break  if @status==:Stop
    }
    break if @status==:Stop
  }

end


=end