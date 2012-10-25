#usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift

loop do
  angle = rand 180
  puts angle
  arduino.servo_write 11, angle
  sleep 1
end
