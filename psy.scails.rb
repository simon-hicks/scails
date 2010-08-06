$midi = Scails::MIDIator::Interface.new
$midi.autodetect_driver
set_tempo(0.5, :bars_per_second)
$key = k('Amin')

$redrum = i($midi, 0)

def $redrum.woodblock time
  _ = false
  dur = 0.5.bars
  tick = 0.25.beats
  [36,_,_,_ ,37,_,37,_].each_with_index do |v, i|
    play_at(time + (i * tick), v, tick) if v
  end
  loop_at(time + dur, :woodblock) if self.repeat
end

$redrum.start(next_bar, :woodblock)

def chords time, this_chord = 'i'
  $chord = c($key, this_chord)
  puts $chord
  next_chord = {
    'i'   => ['i','v'],
    'v'   => ['iv'],
    'iv'  => ['i']
  }[this_chord].choose
  dur = 1.bar
  loop_at(time + dur, :chords, next_chord)
end

$guitar = i($midi, 1)

def $guitar.strum time
  rhythm, volume = [
    [[1  ,0.5,  1,0.5,0.5,0.5], [100,80,100,80,80,80]],
    [[0.5,1  ,0.5,0.5,1  ,0.5], [80,100,80,100,80,80]]
  ].wchoose([3,1])
  vol =    [100, 80,100, 80, 80, 80]
  i=0
  rhythm = rhythm.map(&:beat)
  next_time = rhythm.inject(time) do |mem, d|
    $chord.each{|n| play_at(mem, n + 4.octaves, d, vol[i])}
    i+=1
    mem + d
  end
  loop_at(next_time, :strum) if self.repeat
end

Scails::Clock.instance.at(next_bar) { |t| chords(t, 'i') }

$guitar.start(next_bar + 1.bar, :strum)

$redrum.stop
$guitar.stop
