#!/usr/bin/env ruby

%w(array string kernel object numeric).each { |f| require File.join(File.dirname(__FILE__), "../extensions", f) }
