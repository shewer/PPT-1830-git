require "./gpib.rb"
class PPT_1830
  attr_accessor :addr
  attr_reader :gpib 
  def initialize(gpib,addr)
    @gpib=gpib
    @addr=addr  
    @channel=get_chan()
  end
  
  def set_chan(ch)
    return "channel 1~3" if !(ch<=3 && ch >0)
    set_gpib_addr
    #return ch if channel()== ch
    @gpib.write("chan " + ch.to_s)
    @channel=get_chan()
  
  end
  
  def get_chan()
    set_gpib_addr
    @gpib.write("chan?")
    @gpib.read().to_i
    
  end

  def channel(); @channel ; end
  def channel=(ch ); set_chan ch  ; end
  
  
  def turn=(flag)
    set_gpib_addr
    return @gpib.write("outp:stat 1") if flag==:On
    return @gpib.write("outp:stat 0") if flag==:Off
         
  
    
  end
  def test(a=@channel)
    puts a
  end
  def test1(a=self.channel)
    puts a
  end
  
  
  
  def chk_gpib_addr()
    @addr==@gpib.addr
     
  end
  def set_gpib_addr()
     @gpib.addr= @addr if !chk_gpib_addr   
     return  @addr= @gpib.addr
  end

  
  def set_volt(vol,chan=self.channel)
    set_gpib_addr
    self.channel=chan
    @gpib.write("volt " + vol.to_s)
    
  end
  def set_curr(curr,chan=self.channel)
    set_gpib_addr
    self.channel=chan
    @gpib.write("curr " + curr.to_s)
    
  end
  
  def set_voltp(vol,chan=self.channel)
    set_gpib_addr
    self.channel=chan
    @gpib.write("volt:prot " + vol.to_s)
    
  end
  
  def get_volt(chan=self.channel)
    set_gpib_addr
     self.channel=chan
     @gpib.write("volt?")
     @gpib.read().to_f
  end
  def get_curr(channel=self.channel)
    set_gpib_addr
    self.channel=channel
    @gpib.write("curr?")
    @gpib.read().to_f
  end
  
  def get_voltp(chan=self.channel)
    set_gpib_addr
     self.channel=chan
     @gpib.write("volt:prot?")
     @gpib.read().to_f
  end
  
  def mes_volt(channel=self.channel)
    set_gpib_addr
    self.channel=channel
    puts channel()
    @gpib.write("meas:volt?")
    @gpib.read().to_f
  end
  def mes_curr(channel=self.channel)
    set_gpib_addr
     self.channel=channel
     @gpib.write("meas:curr?")
     @gpib.read().to_f
   end
  
  def get_allch()
    setch=[]
    (1..3).each {|x|
    
          setch.push({:Vol=>get_volt(x),:Cur=>get_curr(x)}) 
 
      }
    setch
    
  end
  def mes_allch()
    mesch=[]
    (1..3).each {|x|
    
          mesch.push({:Vol=>mes_volt(x),:Cur=>mes_curr(x)}) 
 
      }
    mesch
    
  end
  def recall=(rno)
    @gpib.write("*rcl " + rno.to_s)
  end
  def recall()
    @gpib.write("*rclL")
    @gpib.read()
  end
  def save_recall=(rno)
    @gpib.write("*sav " + rno.to_s)
  end
  def getinfo()

     puts "Device: %s " % @gpib.write("*idn?",true)
    
    (1..3).each {|ch|
      @gpib.write("chan %i " %ch )
      puts  "channel %s Volt %5.3f " % [ch ,self.get_volt(ch)]
      
      puts  "channel %s volt prot %5.3f " % [ch ,self.get_voltp(ch)]
      
      puts  "channel %s curr %5.3f" % [ch ,self.get_curr(ch)]
      
      
      
       }
    
  end


end
