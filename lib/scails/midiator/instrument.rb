#!/usr/bin/env ruby

class Scails::MIDIator::Instrument
  include Scails::Instrument

  def initialize interface, channel=0, control_map={}
    @interface = interface
    @channel = channel
    control_map.each { |name, control_number| self.map_control(name, control_number) }
  end

  def play note, duration, volume = 80
    @interface.play note, duration, @channel, volume
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
