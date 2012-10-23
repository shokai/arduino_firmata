#usr/bin/env ruby
$:.unshift File.dirname(__FILE__)
require 'arduino_firmata'

p ArduinoFirmata.list
arduino = ArduinoFirmata.new ArduinoFirmata.list[0]

loop do
  a = arduino.analog_read 0
  puts a
  arduino.analog_write 11, a/4
  sleep 0.1
end

loop do
  arduino.pin_mode 7, ArduinoFirmata::INPUT
  puts arduino.digital_read 7
  sleep 0.5
end

10.times do

  puts :high
  0.upto(255) do |i|
    arduino.analog_write 11, i
    sleep 0.01
  end
  
  arduino.digital_write 13, ArduinoFirmata::HIGH

  puts :low
  255.downto(0) do |i|
    arduino.analog_write 11, i
    sleep 0.01
  end

  arduino.digital_write 13, ArduinoFirmata::LOW
  sleep 1
end
