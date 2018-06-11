# frozen_string_literal: true

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'inspec-hpe-oneview/cli'
require 'inspec-hpe-oneview/version'
require 'train/transports/oneview'
