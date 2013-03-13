## use samples/sysex/SysexLedBlinkFirmata/SysexLedBlinkFirmata.ino

require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestSysex < MiniTest::Unit::TestCase

  def setup
    @arduino = ArduinoFirmata.connect ENV['ARDUINO']
  end

  def teardown
    @arduino.close
  end

  def test_sysex_command
    __cmd = nil
    __data = nil
    @arduino.on :sysex do |cmd, data|
      __cmd = cmd
      __data = data
    end

    @arduino.sysex 0x01, [13, 3, 2]

    100.times do
      sleep 0.1
      break if __cmd != nil
    end

    assert __cmd == 0x01
    assert __data == [13, 0, 3, 0, 2, 0]
  end

end
