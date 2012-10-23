#usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'

arduino = ArduinoFirmata::Arduino.new ARGV.shift

loop do
  an = arduino.analog_read 0
  puts an
  arduino.analog_write 9, an/4
  sleep 0.1
end
