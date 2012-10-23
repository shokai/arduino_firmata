#usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'

arduino = ArduinoFirmata::Arduino.new ARGV.shift

stat = true
loop do
  puts stat
  arduino.digital_write 13, stat
  stat = !stat
  sleep 0.1
end

