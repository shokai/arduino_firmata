#usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift
pin_num = 11

loop do
  puts "-"*10
  0.upto(255) do |i|
    puts i
    arduino.analog_write pin_num, i
    sleep 0.01
  end

  puts "-"*10
  255.downto(0) do |i|
    puts i
    arduino.analog_write pin_num, i
    sleep 0.01
  end
end
