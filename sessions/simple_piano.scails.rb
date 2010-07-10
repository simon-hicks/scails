@midi = Scails::MIDIator::Interface.new
@midi.use(:dls_synth)
@piano = i(@midi, 0)
$key = Scails::Key.new 'Amin'

def @piano.chords time, degree
  chord = c($key, degree)
  chord.each{|n| play n+60 , 4.beat, 80}
  new_degree = {
    'I'    => ['IV', 'VI'],
    'IV'   => ['I'],
    'VI'   => ['IV']
  }[degree].choose
  at(time + 4.beat, :chords, new_degree)
end

def @piano.walk time, last_degree = 45
  if last_degree >= 35 && last_degree <= 55
    new_degree = last_degree + [-2,-1,0,1,2].choose
  else
    new_degree = 50
  end
  dur = [0.5,0.5,1].choose.beat
  volume = (60..80).to_a.choose
  play($key.at(new_degree), dur, volume)
  at(time + dur, :walk, new_degree)
end

def @piano.slow_descent time, last_degree = 55
  if last_degree <= 30
    new_degree = 55
  else
    new_degree = last_degree - 1
  end
  dur = 0.5.beat
  4.times do |i|
    vol = (50..70).to_a.choose
    play_at(time + (i * dur), $key.at(new_degree), dur, vol)
  end
  at(time + (4 * dur), :slow_descent, new_degree)
end

@piano.start next_bar, :chords, 'I'

@piano.start next_bar, :walk

@piano.slow_descent next_bar

@piano.stop

exit
