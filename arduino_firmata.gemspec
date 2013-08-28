lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arduino_firmata/version'

Gem::Specification.new do |gem|
  gem.name          = "arduino_firmata"
  gem.version       = ArduinoFirmata::VERSION
  gem.authors       = ["Sho Hashimoto"]
  gem.email         = ["hashimoto@shokai.org"]
  gem.description   = %q{Arduino Firmata protocol (http://firmata.org) implementation on Ruby.}
  gem.summary       = gem.description
  gem.homepage      = "http://shokai.github.com/arduino_firmata"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/).reject{|i| i=="Gemfile.lock" }
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'bundler', '~> 1.3'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'backports'

  gem.add_dependency 'serialport', '>= 1.1.0'
  gem.add_dependency 'args_parser', '>= 0.1.4'
  gem.add_dependency 'event_emitter', '>= 0.2.4'
end
