require 'test/unit'
require_relative "modbus_package"

def gchksum(str)
  ar=str.bytes
  sum=0
  s=ar.pop
  ar.each{|x| sum += x}
  ar.push sum
  ar.pack("C*")
end
T1=[0x55,01,0x13, 00,00,00,0xaa, 00]
class TestModbus < Test::Unit::TestCase
  def test_simple
    p gchksum(T1.pack("C*"))
    # assert_equal(gchksum(T1.pack("C*")), 
    # ModBus_Package.new(1,0x13,"\x00\x00\x00\x00",:send).to_s,"error 1" )
    assert_equal(gchksum(T1.pack("C*")),
      ModBus_Package.new("\x55\x01\x13\x00\x00\x00\xaa\x00").to_s ,"error2")
  end
  
  
end


