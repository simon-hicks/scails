#!/usr/bin/env ruby

module Scails::Instrument
  def self.included klass
    klass.send :attr_accessor, :repeat
  end

  def play_at time, *args
    Scails::Clock.instance.at time do |t|
      self.play *args
    end
  end

  # stops BEFORE the specified time, so that if you run #stop(next_bar) it stops at the end of the bar... (rather than running the loop one more time)
  def stop time = nil
    unless time
      self.repeat = false
    else
      Scails::Clock.instance.before(time) do |t|
        self.repeat = false
      end
    end
    nil
  end

  def go
    self.repeat = true
  end

  def start time, method, *args
    self.repeat = true
    Scails::Clock.instance.at time do |t|
      self.send(method, t, *args)
    end
  end
end
