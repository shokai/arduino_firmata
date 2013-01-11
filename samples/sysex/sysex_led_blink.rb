#!/usr/bin/env ruby
$:.unshift File.expand_path '../../lib', File.dirname(__FILE__)
require 'rubygems'
require 'arduino_firmata'

arduino = ArduinoFirmata.connect ARGV.shift
puts "firmata version #{arduino.version}"

arduino.send_sysex 0x01, [13, 5, 2]  # pin13, blink 5 times, 200 msec interval
arduino.send_sysex 0x01, [11, 3, 10]  # pin11, blink 3 times, 1000 msec interval
