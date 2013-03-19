# Arduino Firmata Samples

Digital/Analog IO
-----------------
- analog_read_write.rb
- digital_read.rb
- eventmachine.rb
- led_blink.rb
- led_fade.rb
- on_analog_read.rb
- on_digital_read.rb
- servo.rb
- tweet_temperature.rb

Sysex Command
-------------
- sysex/sysex_led_blink.rb


EventMachine
------------

    % gem install eventmachine
    % ruby eventmachine.rb


Sinatra Arduino
---------------

    % gem install sinatra eventmachine
    % ruby sinatra_arduino.rb

=> http://localhost:4567


Tweet Temperature
-----------------

    % gem install tw
    % tw --user:add
    % ruby tweet_temperature.rb

