#!/usr/bin/env ruby

module Scails::Instrument
  def self.included mod
    mod.attr_accessor :stop
  end

  def self.play_at time, *args
    Scails::Clock.instance.at time do |t|
      self.play *args
    end
  end

  def self.at time, method, *args
    unless @stop
      Scails::Clock.instance.at time do |t|
        self.send(method, t, *args)
      end
    end
    nil
  end

  def self.before time, method, *args
    unless @stop
      Scails::Clock.instance.before time do |t|
        self.send(method, t, *args)
      end
    end
    nil
  end

  # stops BEFORE the specified time, so that if you run #stop(next_bar) it stops at the end of the bar... (rather than running the loop one more time)
  def self.stop time = nil
    unless time
      @stop = true 
    else
      Scails::Clock.instance.before(time) do |t|
        self.stop
      end
    end
    nil
  end

  def self.start time, method, *args
    @stop = false
    Scails::Clock.instance.at time do |t|
      self.send(method, t, *args)
    end
  end
end
