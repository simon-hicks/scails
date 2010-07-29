module Kernel
  alias :l :lambda
  
  # Calls Kernel#eval with the given args but catches posible errors
  def resilient_eval *args
    begin
      begin
        eval *args
      rescue SyntaxError => e
        e
      end
    rescue => e
      e
    end
  end
  
  def p obj #:nodoc:
    puts obj.to_live_output
  end
  
  def warn string
    p Scails::Live::Warning.new "warning: #{ string }"
  end

  extend  Scails::Shortcuts::Music
  extend  Scails::Shortcuts::Scheduling
end

class Object
  include Scails::Shortcuts::Music
  include Scails::Shortcuts::Scheduling
end
