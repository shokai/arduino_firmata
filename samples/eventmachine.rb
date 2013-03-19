#!/usr/bin/env ruby
require 'rubygems'
$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'eventmachine'
require 'arduino_firmata'

EM::run do
  arduino = ArduinoFirmata.connect ARGV.shift, :nonblock_io => true ,:eventmachine => true

  arduino.on :analog_read do |pin, value|
    puts "analog_read #{pin} => #{value}" if pin == 0
  end

  arduino.pin_mode 2, ArduinoFirmata::INPUT
  arduino.on :digital_read do |pin, status|
    puts "digital_read #{pin} => #{status}" if pin == 2
  end

  led_stat = false
  EM::add_periodic_timer 1 do
    puts led_stat
    arduino.digital_write 13, led_stat
    led_stat = !led_stat
  end
end
