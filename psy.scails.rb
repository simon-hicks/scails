@midi = Scails::MIDIator::Interface.new
@midi.autodetect_driver
set_tempo(0.5, :bars_per_second)
$key = k('Amin')

# instruments

@bass = i(@midi, 0)
@kick = i(@midi, 1)
@pads = i(@midi, 2)
@lead1 = i(@midi, 3)

@pads.map_control :wheel, 1

# chords

def chord_seq time, chord = 'i'
  $chord = c($key, chord)
  next_chord = {'i' => ['iv', 'ii'],
                'ii'=> ['vi'],
                'iv'=> ['i'],
                'vi' => ['iv']}[chord].choose
  Scails::Clock.instance.at(next_bar) { |t| chord_seq(t, next_chord) }
end

def kick_and_bass time
  @kick.play(30, 0.25.beat)
  notes = [$chord[0], $chord[2], $chord[0]].map{|n| n + 3.octaves}
  3.times{|i| @bass.play_at(time + ((i + 1.0)/4.0).beats, notes[i], 0.25.beats, 100)}
  Scails::Clock.instance.at(next_beat) { |t| kick_and_bass(t) }
end

module Scails::Shortcuts
  def hello
    puts "this is hello from Scails"
  end
end
extend Scails::Shortcuts

puts self.class.class

hello

def @pads.chords time
  play($chord + 3.octaves, 1.bar)
  10.times do |i| 
    at(time + (0.1*i), :wheel=, (127 * sinr(Time.now, 10)))
  end
  at(next_bar, :chords)
end

def @lead1.arps time
  3.times {|i| play_at(time + (i/3.0).beats, $chord[i] + 5.octaves, 0.33.beats)}
  at(next_beat, :arps)
end

@pads.start(next_bar, :chords)

@lead1.start(next_bar, :arps)

@pads.stop

@lead1.stop

Scails::Clock.instance.at(next_bar) { |t| chord_seq(t); kick_and_bass(t) }
Scails::Clock.instance.at(next_bar) { |t| kick_and_bass(t) }

exit
