#require './gpib.rb'
#require './rs485io.rb'
require './ppt1830.rb'
require './ioboard88.rb'
require './test_proc.rb'
require './testunit.rb'

# controller  
# init  io device
# init test unit
# init test proc
# run loop




class Controller
  def initialize()
    @ppt1830=init_ppt1830()
    @ioboard=init_ioboard()
    @status= :Org
    @unit=nil
    @input_def={:Reset=>0x01,:Start=>0x2,:T0=>0x00,:T1=>0x10,:T2=>0x20,:T3=>0x40,:T4=>0x80}
    @tproc=nil
    
    #run()
  end
  def add_test_proc(ar)
    @tproc=ar
  end
  
  def init_ppt1830()
    
    PPT_1830.new(Gpib.new("192.168.3.221",1234),7)
  end
  def init_ioboard()
    Ioboard88.new(Rs485_IO.new("192.168.3.231",6000),1)
  end
  def init_unit()
    
    str=@ioboard.get_io_status()
    un=3 #(str.bytes[4] & 0x0c)>>2 + 1
    @unit=[:T1,:T2,:T3,:T4][0..un].collect {|u| 
      TestUnit.new(u,4,@ioboard,@ppt1830,@tproc)
      
      }
    
  end
  
  
  
=begin
  def run()
     loop {  
       case  @status
         when :Org
           command
              chk_input([:Reset,:Start])
           
         when :Testing
           command
              chk_input([:Reset])
           
         when :Tested
           command 
              chk_input([:Reset,:Start,:T1,:T2,:T3,:T4])
           
           
       end
         

       
       
       
       
       
     }
  
  end


  
  
  def chk_input(input_ar)
    flag=@ioboard.io_status[4] 
    input_ar.each{|f|
      return f if ()@input_def[f] & flag)!=0 
    } return nil 
    
  end
  def command(input)
    case input
    when :Reset 
      reset()
    when :Start
      start()
    when :T1,:T2,:T3,:T4
      chk_test_res(input)
    end
       
  end
=end 
  
  def start()
    @status=:Testing
    process()
    
  end
  
  
  
  def run1()
    @unit.collect {|u|  u.run}
  end
  
  def reset()
    #power off (V=0 I=0)   IO :T0 :C0
    #clear status

    @ppt1830.set_curr(0,3)
    @ioboard.reset()
    @status=:Org
    
    
  end
  
  def chk_button()
    
  end
  
  
  def run_proc()
    
  end
  
  
  
  
end