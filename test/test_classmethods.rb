require File.expand_path 'test_helper', File.dirname(__FILE__)

class TestClassMethods < MiniTest::Test

  def test_arduino_list
    assert ArduinoFirmata::list.class == Array
  end

end
