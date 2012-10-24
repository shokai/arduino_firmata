module ArduinoFirmata

  def self.list
    Dir.entries('/dev').grep(/tty\.?usb/i).map{|fname| "/dev/#{fname}"}
  end

  def self.connect(serial_name=nil, params={})
    serial_name = self.list[0] unless serial_name

    Params.default.each do |k,v|
      params[k] = v unless params[k]
    end

    Arduino.new serial_name, params
  end

end
