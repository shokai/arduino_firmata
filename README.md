arduino_firmata
===============

* Arduino Firmata protocol (http://firmata.org) implementation on Ruby.
* http://shokai.github.com/arduino_firmata


Install
-------

    % gem install arduino_firmata


Requirements
------------

* Ruby 1.8.7 or 1.9.2 or 1.9.3 or 2.0.0
* Arduino (http://arduino.cc)
  * testing with Arduino Duemillanove, UNO, Leonardo, Micro, Seeduino v2.
* Arduino Standard Firmata v2.2
  * Arduino IDE -> [File] -> [Examples] -> [Firmata] -> [StandardFirmata]


ArduinoFirmata Command
----------------------

    % arduino_firmata --help
    % arduino_firmata --list
    % arduino_firmata digital_write 13, true
    % arduino_firmata analog_read 0
    % arduino_firmata servo_write 9, 145


Synopsis
--------

- https://github.com/shokai/arduino_firmata/tree/master/samples

### Setup

Connect
```ruby
require 'arduino_firmata'

arduino = ArduinoFirmata.connect  # use default arduino
arduino = ArduinoFirmata.connect '/dev/tty.usb-device-name'
arduino = ArduinoFirmata.connect '/dev/tty.usb-device-name', :bps => 57600
arduino = ArduinoFirmata.connect '/dev/tty.usb-device-name', :nonblock_io => true
arduino = ArduinoFirmata.connect '/dev/tty.usb-device-name', :eventmachine => true
```

Board Version
```ruby
puts "firmata version #{arduino.version}"
```

Close
```ruby
arduino.close
```


### I/O

Digital Write
```ruby
arduino.digital_write 13, true
arduino.digital_write 13, false
```

Digital Read
```ruby
arduino.pin_mode 7, ArduinoFirmata::INPUT
puts arduino.digital_read 7  # => true/false

arduino.on :digital_read do |pin, status|
  if pin == 7
    puts "digital pin #{pin} changed : #{status}"
  end
end
```

Analog Write (PWM)
```ruby
0.upto(255) do |i|
  arduino.analog_write 11, i
  sleep 0.01
end
```

Analog Read
```ruby
puts arduino.analog_read 0  # => 0 ~ 1023

arduino.on :analog_read do |pin, value|
  if pin == 0
    puts "analog pin #{pin} changed : #{value}"
  end
end
```

Servo Motor
```ruby
loop do
  angle = rand(180)
  arduino.servo_write 11, angle
  sleep 1
end
```


### Sysex

- http://firmata.org/wiki/V2.1ProtocolDetails#Sysex_Message_Format
- https://github.com/shokai/arduino_firmata/tree/master/samples/sysex

Send
```ruby
arduino.sysex 0x01, [13, 5, 2]  # command, data_array
```

Regist Receive Event
```ruby
arduino.on :sysex do |command, data|
  puts "command : #{command}"
  puts "data    : #{data.inspect}"
end
```


### Block Style

```ruby
ArduinoFirmata.connect do
  puts "firmata version #{version}"

  30.times do
    an = analog_read 0
    analog_write 11, an
    sleep 0.01
  end
end
```

Test
----

### Install SysexLedBlinkFirmata into Arduino

* https://github.com/shokai/arduino_firmata/blob/master/samples/sysex/StandardFirmataWithLedBlink/StandardFirmataWithLedBlink.ino


### Run Test

    % gem install bundler
    % bundle install
    % export ARDUINO=/dev/tty.usb-device-name
    % rake test


Contributing
------------
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request