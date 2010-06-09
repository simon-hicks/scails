#!/usr/bin/env ruby

module Scails
end

%w(rubygems singleton dl/import dl/struct tempfile highline platform).each do |f|
  require f
end

require File.expand_path(File.dirname(__FILE__) + '/scails/live')
require File.expand_path(File.dirname(__FILE__) + '/scails/extensions')
require File.expand_path(File.dirname(__FILE__) + '/scails/clock')
require File.expand_path(File.dirname(__FILE__) + '/scails/metronome')
require File.expand_path(File.dirname(__FILE__) + '/scails/midiator')
require File.expand_path(File.dirname(__FILE__) + '/scails/instrument')
