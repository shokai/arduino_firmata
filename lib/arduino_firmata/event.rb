module ArduinoFirmata
  class Arduino

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
