$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'serialport'
require 'stringio'
require 'arduino_firmata/main'
require 'arduino_firmata/const'
require 'arduino_firmata/arduino'

module ArduinoFirmata
  VERSION = '0.0.3'
end
