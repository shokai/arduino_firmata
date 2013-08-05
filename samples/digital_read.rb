#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift

arduino.pin_mode 2, ArduinoFirmata::INPUT

loop do
  if arduino.digital_read 2
    puts "on"
    arduino.digital_write 13, true
  else
    puts "off"
    arduino.digital_write 13, false
  end
  sleep 0.1
end
