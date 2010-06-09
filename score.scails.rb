@dls = Scails::MIDIator::Interface.new
@dls.use :dls_synth
set_tempo(0.5, :bars_per_second)
@left = Scails::Instrument.new(@dls, 0) 
def @left.chords time, notes
  notes.each do |n|
    Scails::Clock.instance.at(time) { |t| play(n+60, 4.beats) }
  end
  at(time + 3.9.beats, :chords, notes)
end

@left.start(next_bar, :chords, [0,4,7])
@left.stop 
exit
