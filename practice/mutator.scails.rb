$dls = Scails::MIDIator::Interface.new
$dls.use :dls_synth
$key = k('Cmaj')
$piano = i($dls, 0)
def $piano.mutator time, melody = nil
  length = 16
  if melody.nil?
    melody = m([])
    degree = 15
    length.times{melody << degree; degree = melody.degrees.last + [-2,-1,0,1,2].wchoose([1,3,1,3,1])}
  end
  i = 0
  dur = 1.beat
  puts melody
  melody.each($key) {|n| play_at(time + (i * dur), n + 4.octaves, dur); i += 1}
  new_melody = transform(melody)
  loop_at(time + (length * dur), :mutator, new_melody) if self.repeat
end
def $piano.transform melody
 melody.send([:invert,:retrograde].choose)
end

$piano.start next_beat, :mutator

$piano.stop

exit
