require './ppt1830.rb'

class TestProc
  attr_reader :jug, :test_res
  def initialize(ppt,tproc)
    @ppt=ppt
    @@conpro=add_proc(tproc)
    @test_res=nil
    @jug=nil
    
  end
  
  def add_proc(con_ar)
    @@conproc=con_ar
  end
  
  def run()
    
    @ppt.set_volt(0,3)
    @ppt.set_curr(0.2,3) # ppt power on
     
    ar= @@conproc.collect { |v,j|
          @ppt.set_volt(v,3)
          sleep 0.1
          curr=@ppt.mes_curr
          jgu=  curr >0.05 
          [curr,jgu]
    }
    @ppt.set_curr(0,3)
   
    @test_res=ar.transpose
    @jug= @test_res[1]== @@conproc.transpose[1]
    
  end
  def clean()
    @jug=nil
    @test_res=nil
  end
  
  
end