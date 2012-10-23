# -*- coding: utf-8 -*-
#usr/bin/env ruby
require 'rubygems'
require 'tw'
require 'arduino_firmata'

arduino = ArduinoFirmata.new

puts temp = arduino.analog_read(1)*100*5/1024
client = Tw::Client.new
client.auth 'shokai'
client.tweet "現在の気温 #{temp}度"
