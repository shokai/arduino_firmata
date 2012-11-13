#usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

ArduinoFirmata.connect ARGV[0] do
  puts "firmata version #{version}"
  led_stat = false

  3.times do
    digital_write(13, led_stat = !led_stat)
    puts "led : #{led_stat}"
    puts "analog : #{analog_read 0}"

    [(0..255).to_a, (0..255).to_a.reverse].flatten.each do |i|
      analog_write(11, i)
      sleep 0.01
    end
  end
  
end
