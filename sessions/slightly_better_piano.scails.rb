@midi = Scails::MIDIator::Interface.new
@midi.use(:dls_synth)
@piano = i(@midi, 0)
$key = Scails::Key.new 'Amaj'

def @piano.chords time, degree
  @chord = c($key, degree)
  @chord.each{|n| play n+60 , 4.beat, 80}
  new_degree = {
    'I'    => ['IV', 'VI', 'II'],
    'II'   => ['IV'],
    'IV'   => ['I', 'V'],
    'V'    => ['VI','IV'], 
    'VI'   => ['IV']
  }[degree].choose
  at(time + 4.beat, :chords, new_degree)
end

def @piano.arp time, last_index = 5
  arp = @chord.chord(40,80,10)
  if last_index < (arp.size - 1) && last_index > 0
    new_index = last_index + [-1, 0, 1].wchoose([2,1,2])
  elsif last_index >= (arp.size - 1)
    new_index = last_index + [-1, -1, 0].choose
  elsif last_index <= 0
    new_index = last_index + [0, 1, 1].choose
  end
  dur = [0.5, 0.5, 1].choose.beats
  volume = (60..80).to_a.choose
  play(arp[new_index], dur, volume)
  at(time + dur, :arp, new_index)
end

def @piano.walk time, last_degree = 45
  if last_degree >= 35 && last_degree <= 55
    new_degree = last_degree + [-1,1].choose
  else
    new_degree = 50
  end
  number = [2, 4].choose
  number.times do |i| 
    volume = (60..80).to_a.choose
    play_at(time + (i/2.0).beat, $key.at(new_degree), 0.5, volume)
  end
  at(time + (number/2).beat, :walk, new_degree)
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

@piano.start next_bar, :arp

@piano.start next_bar, :slow_descent


@piano.stop

exit
