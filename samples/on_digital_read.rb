#usr/bin/env ruby
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift
arduino.pin_mode 2, ArduinoFirmata::INPUT

arduino.on :digital_read do |pin, status|
  if pin == 2
    puts "digital pin #{pin} changed : #{status}"
  end
end

led_stat = false
loop do
  arduino.digital_write 13, led_stat
  led_stat = !led_stat
  sleep 1
end
