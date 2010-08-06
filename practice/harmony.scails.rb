$dls = Scails::MIDIator::Interface.new
$dls.use :dls_synth
$key = k('Cmaj')
$piano = i($dls, 0)
$transitions = {
      1 => [4,5],
      3 => [4,5],
      4 => [1,3,5,6],
      5 => [1,4,6],
      6 => [4,5]
}
def generate_melody length = 16
  raise "Minimum length is 4" unless length > 3
  melody = m(1)
  (length - 3).times do
    melody << $transitions[melody.last].choose
  end
  melody << [4,5].reject{|e| e == melody.last}.choose << 1
end

def $piano.base_melody time, melody, index = 0
  $base_degree = melody[index]
  dur = 1.bar
  note = $key.at($base_degree) + 4.octaves
  play(note, dur)
  loop_at(time + dur, :base_melody, melody, index + 1) if self.repeat
end

def $piano.second time, last_degree = nil
  degree = 0
  4.times do |i|
    if last_degree
      degree = $key.consonant_degrees($base_degree).sort{|d| (d - last_degree).abs}.first
    else
      degree = $key.consonant_degrees($base_degree).choose
    end
    play_at(time + (1 * i).beats, $key.at(degree) + 4.octaves, 2.beats)
  end
  loop_at(time + 1.bar, :second, degree) if self.repeat
end

$piano.start next_bar, :base_melody, generate_melody(8)
$piano.start next_bar, :second

$piano.stop

exit

