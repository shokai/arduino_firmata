require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestBlock < MiniTest::Unit::TestCase

  def test_block
    version_ = nil
    ArduinoFirmata.connect ENV['ARDUINO'] do
      version_ = version
    end
    assert version_ and version_ > '2.0'
  end

end
