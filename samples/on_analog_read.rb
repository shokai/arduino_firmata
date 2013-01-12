#usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift

arduino.on :analog_read do |pin, value|
  if pin == 0
    puts "analog pin #{pin} changed #{value}"
    arduino.analog_write 11, value
  end
end

led_stat = false
loop do
  arduino.digital_write 13, led_stat
  led_stat = !led_stat
  sleep 1
end
