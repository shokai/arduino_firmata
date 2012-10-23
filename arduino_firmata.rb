require 'serialport'
require 'stringio'

class ArduinoFirmata

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

  def initialize(serial_name, bps=57600)
    @wait_for_data = 0
    @execute_multi_byte_command = 0
    @multi_byte_channel = 0
    @stored_input_data = []
    @parsing_sysex = false
    @sysex_bytes_read

    @digital_output_data = Array.new(16, 0)
    @digital_input_data = Array.new(16, 0)
    @analog_input_data = Array.new(16, 0)

    @major_version
    @minor_version

    @serial = SerialPort.new(serial_name, bps, 8, 1, 0)
    sleep 3

    Thread.new{
      loop do
        process_input
        sleep 0.1
      end
    }.run

    (0...6).each do |i|
      write(REPORT_ANALOG | i)
      write 1
    end
    (0...2).each do |i|
      write(REPORT_DIGITAL | i)
      write 1
    end

  end

  def self.list
    Dir.entries('/dev').grep(/tty\.usb/).map{|fname| "/dev/#{fname}"}
  end

  def write(cmd)
    @serial.write_nonblock cmd.chr
  end

  def read
    @serial.read_nonblock 9600 rescue EOFError
  end

  def digital_read(pin)
    (@digital_input_data[pin >> 3] >> (pin & 0x07)) & 0x01 > 0
  end

  def analog_read(pin)
    @analog_input_data[pin]
  end

  def pin_mode(pin, mode)
    write SET_PIN_MODE
    write pin
    write mode
  end

  def digital_write(pin, value)
    port_num = (pin >> 3) & 0x0F
    if value == 0 or value == true
      @digital_output_data[port_num] &= ~(1 << (pin & 0x07))
    else
      @digital_output_data[port_num] |= (1 << (pin & 0x07))
    end

    write(DIGITAL_MESSAGE | port_num)
    write(@digital_output_data[port_num] & 0x7F)
    write(@digital_output_data[port_num] >> 7)
  end

  def analog_write(pin, value)
    pin_mode pin, PWM
    write(ANALOG_MESSAGE | (pin & 0x0F))
    write(value & 0x7F)
    write(value >> 7)
  end

  def process_input
    bytes = StringIO.new(String(read)).bytes
    bytes.each do |input_data|
      command = nil

      if @parsing_sysex
        if input_data == END_SYSEX
          @parsing_sysex = FALSE
        else
          @stored_input_data[@sysex_bytes_read] = input_data
          @sysex_bytes_read += 1
        end
      elsif @wait_for_data > 0 and input_data < 128
        @wait_for_data -= 1
        @stored_input_data[@wait_for_data] = input_data
        if @execute_multi_byte_command != 0 and @wait_for_data == 0
          case @execute_multi_byte_command
          when DIGITAL_MESSAGE
            @digital_input_data[@multi_byte_channel] = (@stored_input_data[0] << 7) + @stored_input_data[1]
          when ANALOG_MESSAGE
            @analog_input_data[@multi_byte_channel] = (@stored_input_data[0] << 7) + @stored_input_data[1]
          when REPORT_VERSION
            @minor_version = @stored_input_data[1]
            @major_version = @stored_input_data[0]
          end
        end
      else
        if input_data < 0xF0
          command = input_data & 0xF0
          @multi_byte_channel = input_data & 0x0F
        else
          command = input_data
        end
        if [DIGITAL_MESSAGE, ANALOG_MESSAGE, REPORT_VERSION].include? command
          @wait_for_data = 2
          @execute_multi_byte_command = command
        end
    end
    end
  end
  
end
