#usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'

arduino = ArduinoFirmata::Arduino.new ARGV.shift
pin_num = 9

loop do
  puts "0 -> 255"
  0.upto(255) do |i|
    arduino.analog_write pin_num, i
    sleep 0.01
  end
  
  puts "255 -> 0"
  255.downto(0) do |i|
    arduino.analog_write pin_num, i
    sleep 0.01
  end
end
