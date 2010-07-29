module Scails::Shortcuts
  def next_beat beats_per_bar = nil
    beats_per_bar ||= Scails::Metronome.instance.beats_per_bar
    Scails::Metronome.instance.get_next_beat(beats_per_bar)
  end

  def next_bar
    Scails::Metronome.instance.get_next_bar
  end

  def now
    Time.now
  end

  def tempo unit = :bars_per_second
    Scails::Metronome.instance.send(unit)
  end

  def set_tempo value, unit
    Scails::Metronome.instance.send((unit.to_s+'=').to_sym, value)
  end

  # shortcut to create PitchClass objects
  def pc *member_pitches
    Scails::PitchClass.new(member_pitches)
  end

  # shortcut to create Chord objects
  def c *args
    Scails::Chord.new(*args)
  end

  # shortcut to create Rhythm objects
  def r *args
    Scails::Rhythm.new(*args)
  end

  # shortcut to create Instrument objects
  def i *args
    Scails::MIDIator::Instrument.new(*args)
  end

  # shortcut to create Motive objects
  def m *args
    Scails::Motive.new(*args)
  end

  def group *objects
    objects = [objects].flatten
    previous_object = objects.first 
    raise "All arguments to group must be the same class" unless objects.inject(true){|mem, object| result = mem && (object.class == previous_object.class); previous_object = object; result}
    previous_object.class.make_group(*objects)
  end

  def sinr time, frequency
    Math.sin(time.to_f * Math::PI * 2 * frequency)
  end

  def cosr time, frequency
    Math.cos(time.to_f * Math::PI * 2 * frequency)
  end

  def k name
    Scails::Key.new(name)
  end
end

class Scails::Live::Session
  extend Scails::Shortcuts
end