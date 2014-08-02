require './ioboard88.rb'
require './ppt1830.rb'


class TestUnit
      attr_reader :ch,:test_res
  def initialize(ti,chno=4,ioboard,ppt,tproc)

    @ioboard=ioboard

    #暫時測試
    
    
    @ti=ti
    @ch=create_ch(chno,ppt,tproc)
    @tproc=tproc
    @test_res=nil  #[]
    @jug=nil
    
    
  end
  def create_ch(ch_no,ppt,tproc)
    @ch= [:C1,:C2,:C3,:C4][0,ch_no].collect {|c| [c,TestProc.new(ppt,tproc)]}
    
  end
  def run()
    @test_res=@ch.collect {|ch,tp|
       @ioboard.reset()
      @ioboard.relay_set(@ti,ch)
      [ch,tp.run()]
      }
       @ioboard.reset()
      @jug= @test_res.transpose[1] == [true,true,true,true]
      @jug
      
    
  end
  
  def clean()
    
    @ch.each{|ch,tp|
      tp.clean()
      }
    
  end
  
  def get_res_flag()
      @ch.collect{|ch,tp|  [ch,tp.jug]}
  end
  
  def get_res_detail()
    @ch.collect {|ch,tp| [ch,tp.test_res]}
  end
  
  
end
