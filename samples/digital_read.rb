#usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift

arduino.pin_mode 7, ArduinoFirmata::INPUT

loop do
  if arduino.digital_read 7
    puts "on"
    arduino.digital_write 13, true
  else
    puts "off"
    arduino.digital_write 13, false
  end
  sleep 0.1
end
