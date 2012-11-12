module ArduinoFirmata

  def self.list
    Dir.entries('/dev').grep(/tty\.?(usb|acm)/i).map{|fname| "/dev/#{fname}"}
  end

  def self.connect(serial_name=nil, params={}, &block)
    serial_name = self.list[0] unless serial_name

    Params.default.each do |k,v|
      params[k] = v unless params[k]
    end

    arduino = Arduino.new serial_name, params

    unless block_given?
      return arduino
    else
      arduino.instance_eval &block
      arduino.close
    end
  end

end
