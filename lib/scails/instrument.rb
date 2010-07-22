#!/usr/bin/env ruby

module Scails::Instrument
  attr_accessor :stop

  def initialize interface, channel=0, control_map={}
    @interface = interface
    @channel = channel
    control_map.each { |name, control_number| self.map_control(name, control_number) }
  end

  def play note, duration, volume = 80
    @interface.play note, duration, @channel, volume
  end

  def play_at time, note, duration, volume = 80
    Scails::Clock.instance.at time do |t|
      self.play note, duration, volume
    end
  end

  def at time, method, *args
    unless @stop
      Scails::Clock.instance.at time do |t|
        self.send(method, t, *args)
      end
    end
    nil
  end

  def before time, method, *args
    unless @stop
      Scails::Clock.instance.before time do |t|
        self.send(method, t, *args)
      end
    end
    nil
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
    nil
  end

  def start time, method, *args
    @stop = false
    Scails::Clock.instance.at time do |t|
      self.send(method, t, *args)
    end
  end

  def map_control name, control_number
    instance_eval("
      def #{name}= value
        @interface.control_change #{number}, @channel, value
        @#{name} = value
      end

      attr_reader :#{name}")
    nil
  end
end
