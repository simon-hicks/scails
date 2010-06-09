#!/usr/bin/env ruby

module Scails::MIDIator
end

%w(midiator/exceptions midiator/driver_registry midiator/driver midiator/interface).each do |f|
  require File.expand_path(File.dirname(__FILE__) + '/' + f)
end
