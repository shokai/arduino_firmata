module ArduinoFirmata

  def self.list
    Dir.entries('/dev').grep(/tty\.?usb/i).map{|fname| "/dev/#{fname}"}
  end

  INPUT  = 0
  OUTPUT = 1
  ANALOG = 2
  PWM    = 3
  SERVO  = 4
  SHIFT  = 5
  I2C    = 6
  LOW    = 0
  HIGH   = 1

  MAX_DATA_BYTES  = 32
  DIGITAL_MESSAGE = 0x90 # send data for a digital port
  ANALOG_MESSAGE  = 0xE0 # send data for an analog pin (or PWM)
  REPORT_ANALOG   = 0xC0 # enable analog input by pin
  REPORT_DIGITAL  = 0xD0 # enable digital input by port
  SET_PIN_MODE    = 0xF4 # set a pin to INPUT/OUTPUT/PWM/etc
  REPORT_VERSION  = 0xF9 # report firmware version
  SYSTEM_RESET    = 0xFF # reset from MIDI
  START_SYSEX     = 0xF0 # start a MIDI SysEx message
  END_SYSEX       = 0xF7 # end a MIDI SysEx message

end
