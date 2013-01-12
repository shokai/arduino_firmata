require 'rubygems'
require 'bundler/setup'
require 'backports'
require 'minitest/autorun'

$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'
