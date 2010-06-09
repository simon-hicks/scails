#!/usr/bin/env ruby

class Scails::Instrument
  def initialize midi_interface, channel=0
    @midi = midi_interface
    @channel = channel
  end

  def play note, duration, volume = 80
    @midi.play note, duration, @channel, volume
  end

  def at time, method, *args
    unless @stop
      Scails::Clock.instance.at time do |t|
        self.send(method, t, *args)
      end
    end
  end

  def before time, method, *args
    unless @stop
      Scails::Clock.instance.before time do |t|
        self.send(method, t, *args)
      end
    end
  end

  # stops BEFORE the specified time, so that if you run #stop(next_bar) it stops at the end of the bar... (rather than running the loop one more time)
  def stop time = nil
    unless time
      @stop = true 
    else
      Scails::Clock.instance.before(time) do |t|
        self.stop
      end
    end
  end

  def start time, method, *args
    @stop = false
    Scails::Clock.instance.at time do |t|
      self.send(method, t, *args)
    end
  end
end
