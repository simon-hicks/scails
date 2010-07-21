@dls = Scails::MIDIator::Interface.new
@dls.use :dls_synth

def @dls.markov_arpeggiattor time, chord_name
  dur = (1.0/chord.size).beats(4)
  vol = 80
  $chord = c($key, chord_name)
  4.times do |b|
    chord.each{|n| play_at(time + b.beats(4) + dur, n + 3.octaves, dur, vol)} 
  end
  next_chord = {'i'   => ['iv'],
                'iv'  => ['i',]}[chord].choose
  at(next_bar, :markov_arpeggiator, next_chord)
end

def @dls.kick_and_bass time
  4.times do |b|
    @kick.play_at(time, 30, 0.1.beats, 80) if b == 0
    play_at(time + (b.to_f/4).beats, $chord.min + 1.octave, 0.25.beats, 80) unless b == 0
    self.x_control = sinr(time + (b.to_f/4).beats, (1/4.0).bars)
    self.y_control = cosr(time + (b.to_f/4).beats, (1/5.0).bars)
  end
end


exit
