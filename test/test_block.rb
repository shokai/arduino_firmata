require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestBlock < MiniTest::Test

  def test_block
    version_ = nil
    ArduinoFirmata.connect ENV['ARDUINO'] do
      version_ = version
    end
    assert version_ and version_ > '2.0'
  end

  def test_block_analog_read
    ain = nil
    ArduinoFirmata.connect ENV['ARDUINO'] do
      ain = analog_read 0
    end
    assert 0 <= ain and ain < 1024
  end

end
