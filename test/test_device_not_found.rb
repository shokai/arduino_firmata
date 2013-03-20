require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestDeviceNotFound < MiniTest::Unit::TestCase

  def test_nodevice
    err = nil
    begin
      a = ArduinoFirmata.connect nil
    rescue => e
      err = e
    ensure
      a.close
    end
    assert e.kind_of? ArduinoFirmata::Error
  end

end
