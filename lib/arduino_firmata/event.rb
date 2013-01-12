module ArduinoFirmata
  class Arduino

    def on_analog_changed(pin, value=nil, &block)
      if block_given?
        @on_analog_changed.push(:pin => pin, :callback => block)
      else
        @on_analog_changed.each do |func|
          func[:callback].call value if func[:pin] == pin
        end
      end
    end

    def on_sysex_received(command, data=nil, &block)
      if block_given?
        @on_sysex_received.push(:command => command, :callback => block)
      else
        @on_sysex_received.each do |func|
          func[:callback].call data if func[:command] == command
        end
      end
    end

  end
end
