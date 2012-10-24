#usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift

loop do
  an = arduino.analog_read 0
  puts an
  arduino.analog_write 11, an/4
  sleep 0.1
end

