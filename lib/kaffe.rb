libdir = File.dirname(__FILE__)
$:.unshift(libdir) unless $:.include?(libdir)

require 'kaffe/routes'
require 'kaffe/actions'
require 'kaffe/static'
require 'kaffe/settings'
require 'kaffe/base'
