#!/usr/bin/env ruby

module Scails
end

%w(rubygems singleton dl tempfile highline platform).each do |f|
  require f
end

#require 'rubygems' 
#require 'singleton' 
#require 'dl'
#require 'tempfile'
#require 'highline'

require File.expand_path(File.dirname(__FILE__) + '/scails/live')
require File.expand_path(File.dirname(__FILE__) + '/scails/extensions')
require File.expand_path(File.dirname(__FILE__) + '/scails/clock')
require File.expand_path(File.dirname(__FILE__) + '/scails/metronome')
require File.expand_path(File.dirname(__FILE__) + '/scails/midiator')
require File.expand_path(File.dirname(__FILE__) + '/scails/instrument')
#%w(scails/live scails/extensions scails/clock scails/metronome scails/midiator scails/instrument).each do |f|
  #require File.expand_path(File.dirname(__FILE__) + '/' + f)
#end
