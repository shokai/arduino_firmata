require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
require 'backports'

$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'arduino_firmata'
