#!/usr/bin/env ruby

module Scails::Live
  class Notice < String; end
  class Warning < String; end
  class Special < String; end

  class Pipe < Tempfile
    def make_tmpname( *args )
      "ruby_live.pipe"
    end
  end
end

require File.join(File.dirname(__FILE__), "live/session")
