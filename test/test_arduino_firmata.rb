require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestArduinoFirmata < MiniTest::Unit::TestCase

  def setup
    @arduino = ArduinoFirmata.connect
  end

  def test_arduino
    assert @arduino.version > '2.0'

    0.upto(5).each do |pin|
      assert 0 < @arduino.analog_read(pin)
    end
  end
end
