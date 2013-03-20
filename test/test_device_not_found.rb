require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestDeviceNotFound < MiniTest::Unit::TestCase

  def test_nodevice
    err = nil
    begin
      a = ArduinoFirmata.connect 'dummy-device'
    rescue => e
      err = e
    end
    assert e.kind_of? StandardError
  end

end
