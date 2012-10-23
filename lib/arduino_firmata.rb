$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'arduino_firmata/const'
require 'arduino_firmata/main'

module ArduinoFirmata
  VERSION = '0.0.1'
end
