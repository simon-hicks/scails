@midi = Scails::MIDIator::Interface.new
@midi.autodetect_driver
redrum = i(@midi, 2)
def redrum.test time, note = 36
  play(note, 0.5)
  puts note
  next_note = note + 1 > 45 ? 36 : note+1
  at(time + 1, :test, next_note)
end

redrum.start Time.now + 5, :test

redrum.stop
