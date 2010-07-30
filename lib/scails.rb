#!/usr/bin/env ruby

module Scails
end

%w(rubygems singleton dl/import dl/struct tempfile highline platform).each do |f|
  require f
end

%w(clock metronome control_oscillator instrument midiator constants key motive pitch_class chord rhythm shortcuts extensions live).each do |f|
  require File.expand_path(File.dirname(__FILE__) + '/scails/' + f)
end
