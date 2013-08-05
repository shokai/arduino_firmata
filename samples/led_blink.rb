#!/usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift
puts "firmata version #{arduino.version}"

arduino.pin_mode 13, ArduinoFirmata::OUTPUT

stat = true
loop do
  puts stat
  arduino.digital_write 13, stat
  stat = !stat
  sleep 0.1
end

