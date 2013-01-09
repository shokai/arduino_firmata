require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestArduinoFirmata < MiniTest::Unit::TestCase

  def setup
    @arduino = ArduinoFirmata.connect ENV['ARDUINO']
  end

  def test_arduino
    assert @arduino.version > '2.0'
    @arduino.close
  end

  def test_digital_read
    0.upto(13).each do |pin|
      din = @arduino.digital_read pin
      assert [true,false].include? din
    end
    @arduino.close
  end

  def test_analog_read
    0.upto(5).each do |pin|
      ain = @arduino.analog_read pin
      assert 0 <= ain and ain < 1024
    end
    @arduino.close
  end

  def test_digital_write
    0.upto(13).each do |pin|
      assert @arduino.digital_write(pin, true) == true
      assert @arduino.digital_write(pin, false) == false
    end
    @arduino.close
  end

  def test_analog_write
    0.upto(13).each do |pin|
      value = rand(256)
      assert @arduino.analog_write(pin, value) == value
    end
    @arduino.close
  end

  def test_servo_write
    0.upto(13).each do |pin|
      angle = rand(181)
      assert @arduino.servo_write(pin, angle) == angle
    end
    @arduino.close
  end

  def test_pin_mode
    0.upto(13).each do |pin|
      mode = [ArduinoFirmata::OUTPUT, ArduinoFirmata::INPUT].sample
      assert @arduino.pin_mode(pin, mode) == mode
    end
    @arduino.close
  end

end
