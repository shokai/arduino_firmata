module ArduinoFirmata

  class Arduino
    include EventEmitter

    attr_reader :version, :status, :nonblock_io, :eventmachine

    def initialize(serialport_name, params)
      @serialport_name = serialport_name
      @nonblock_io = !!params[:nonblock_io]
      @eventmachine = !!params[:eventmachine]
      @read_byte_size = eventmachine ? 256 : 9600
      @process_input_interval = eventmachine ? 0.0001 : 0.01
      @status = Status::CLOSE
      @wait_for_data = 0
      @execute_multi_byte_command = 0
      @multi_byte_channel = 0
      @stored_input_data = []
      @parsing_sysex = false
      @sysex_bytes_read = 0

      @digital_output_data = Array.new(16, 0)
      @digital_input_data = Array.new(16, 0)
      @analog_input_data = Array.new(16, 0)

      @version = nil

      @serial = SerialPort.new(@serialport_name, params[:bps], params[:bit], params[:stopbit], params[:parity])
      @serial.read_timeout = 10
      sleep 3 if old_arduino_device?
      @status = Status::OPEN

      at_exit do
        close
      end

      @thread_status = false
      run do
        @thread_status = true
        while status == Status::OPEN do
          process_input
          sleep @process_input_interval
        end
        @thread_status = false
      end

      loop do
        write REPORT_VERSION
        sleep 0.5
        break if @version
      end
      sleep 0.5 if old_arduino_device?

      (0...6).each do |i|
        write(REPORT_ANALOG | i)
        write 1
      end
      (0...2).each do |i|
        write(REPORT_DIGITAL | i)
        write 1
      end
    end

    def run(&block)
      return unless block_given?
      if eventmachine
        EM::defer &block
      else
        Thread.new &block
      end
    end

    def old_arduino_device?
      File.basename(@serialport_name) !~ /^tty\.usbmodem/
    end

    def close
      return if status == Status::CLOSE
      @status = Status::CLOSE
      @serial.close
      loop do
        if @serial.closed? and @thread_status != true
          break
        end
        sleep 0.01
      end
    end

    def reset
      write SYSTEM_RESET
    end

    def sysex(command, data=[])
      ## http://firmata.org/wiki/V2.1ProtocolDetails#Sysex_Message_Format
      raise ArgumentError, 'command must be Number' unless command.kind_of? Fixnum
      raise ArgumentError, 'data must be 7bit-Number or Those Array' unless [Fixnum, Array].include? data.class

      write_data = data.kind_of?(Array) ? data : [data]
      write START_SYSEX
      write command
      write_data.each do |d|
        write (d & 0b1111111) # 7bit
      end
      write END_SYSEX
    end

    def digital_read(pin)
      raise ArgumentError, "invalid pin number (#{pin})" if pin.class != Fixnum or pin < 0
      (@digital_input_data[pin >> 3] >> (pin & 0x07)) & 0x01 > 0
    end

    def analog_read(pin)
      raise ArgumentError, "invalid pin number (#{pin})" if pin.class != Fixnum or pin < 0
      @analog_input_data[pin]
    end

    def pin_mode(pin, mode)
      raise ArgumentError, "invalid pin number (#{pin})" if pin.class != Fixnum or pin < 0
      write SET_PIN_MODE
      write pin
      mode = case mode
             when true
               OUTPUT
             when false
               INPUT
             else
               mode
             end
      if write(mode) == 1
        return mode
      end
    end

    def digital_write(pin, value)
      raise ArgumentError, "invalid pin number (#{pin})" if pin.class != Fixnum or pin < 0
      pin_mode pin, OUTPUT
      port_num = (pin >> 3) & 0x0F
      if value == 0 or value == false
        @digital_output_data[port_num] &= ~(1 << (pin & 0x07))
      else
        @digital_output_data[port_num] |= (1 << (pin & 0x07))
      end

      write(DIGITAL_MESSAGE | port_num)
      write(@digital_output_data[port_num] & 0x7F)
      if write(@digital_output_data[port_num] >> 7) == 1
        return value
      end
    end

    def analog_write(pin, value)
      raise ArgumentError, "invalid pin number (#{pin})" if pin.class != Fixnum or pin < 0
      raise ArgumentError, "invalid analog value (#{value})" if value.class != Fixnum or value < 0
      pin_mode pin, PWM
      write(ANALOG_MESSAGE | (pin & 0x0F))
      write(value & 0x7F)
      if write(value >> 7) == 1
        return value
      end
    end

    def servo_write(pin, angle)
      raise ArgumentError, "invalid pin number (#{pin})" if pin.class != Fixnum or pin < 0
      raise ArgumentError, "invalid angle (#{angle})" if angle.class != Fixnum or angle < 0
      pin_mode pin, SERVO
      write(ANALOG_MESSAGE | (pin & 0x0F))
      write(angle & 0x7F)
      if write(angle >> 7) == 1
        return angle
      end
    end

    private
    def write(cmd)
      return if status == Status::CLOSE
      if nonblock_io
        begin
          @serial.write_nonblock cmd.chr
        rescue Errno::EAGAIN
          sleep 0.1
          retry
        end
      else
        @serial.write cmd.chr
      end
    end

    def read
      return if status == Status::CLOSE
      data = nil
      begin
        if nonblock_io
          data = @serial.read_nonblock @read_byte_size
        else
          data = @serial.read @read_byte_size
        end
      rescue IOError, EOFError => e
      end
      data
    end

    def process_input
      StringIO.new(String read).each_byte.each do |input_data|
        command = nil

        if @parsing_sysex
          if input_data == END_SYSEX
            @parsing_sysex = false
            sysex_command = @stored_input_data[0]
            sysex_data = @stored_input_data[1...@sysex_bytes_read]
            emit :sysex, sysex_command, sysex_data
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
              input_data = (@stored_input_data[0] << 7) + @stored_input_data[1]
              diff = @digital_input_data[@multi_byte_channel] ^ input_data
              @digital_input_data[@multi_byte_channel] = input_data
              0.upto(13).each do |i|
                next unless (0x01 << i) & diff > 0
                emit :digital_read, i, (input_data & diff > 0)
              end
            when ANALOG_MESSAGE
              analog_value = (@stored_input_data[0] << 7) + @stored_input_data[1]
              old = analog_read(@multi_byte_channel)
              @analog_input_data[@multi_byte_channel] = analog_value
              emit :analog_read, @multi_byte_channel, analog_value if old != analog_value
            when REPORT_VERSION
              @version = "#{@stored_input_data[1]}.#{@stored_input_data[0]}"
            end
          end
        else
          if input_data < 0xF0
            command = input_data & 0xF0
            @multi_byte_channel = input_data & 0x0F
          else
            command = input_data
          end
          if command == START_SYSEX
            @parsing_sysex = true
            @sysex_bytes_read = 0
          elsif [DIGITAL_MESSAGE, ANALOG_MESSAGE, REPORT_VERSION].include? command
            @wait_for_data = 2
            @execute_multi_byte_command = command
          end
        end
      end
    end
    
  end
  
end
