libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)
require 'tilt'
require 'kaffe/render'
require 'kaffe/error'
require 'kaffe/routes'
require 'kaffe/actions'
require 'kaffe/static'
require 'kaffe/settings'
require 'kaffe/base'
require 'kaffe/version'
