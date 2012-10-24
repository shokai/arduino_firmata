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

  end
end
