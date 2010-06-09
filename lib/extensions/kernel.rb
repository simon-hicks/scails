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

  def next_beat beats_per_bar = nil
    beats_per_bar ||= Scails::Metronome.instance.beats_per_bar
    Scails::Metronome.instance.get_next_beat(beats_per_bar)
  end

  def next_bar
    Scails::Metronome.instance.get_next_bar
  end

  def tempo unit = :bars_per_second
    Scails::Metronome.instance.send(unit)
  end

  def set_tempo value, unit
    Scails::Metronome.instance.send((unit.to_s+'=').to_sym, value)
  end
end
