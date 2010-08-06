@midi = Scails::MIDIator::Interface.new
@midi.autodetect_driver
set_tempo(0.5, :bars_per_second)
$key = k 'Amin'
@mixer = i(@midi, 0, :channel_1_level => 8,
                     :channel_2_level => 9,
                     :channel_3_level => 10,
                     :channel_4_level => 12,
                     :channel_5_level => 13,
                     :channel_6_level => 14,
                     :channel_7_level => 15,
                     :channel_8_level => 16,
                     :channel_9_level => 17)
$motives = []
def create_motive
  start_note  = [1,5,8].wchoose([4,1,2])
  end_note    = [1,8].wchoose([1,1])
  other_notes = []
  3.times{ other_notes << [1,2,3,4,5,6,7,8].wchoose([2,4,6,4,6,1,1,2])}
  return m(other_notes.sort_by{|a| rand} << end_note).unshift(start_note)
end
4.times{$motives << create_motive}

@atmos_pad = i(@midi, 1)
@redrum = i(@midi, 2)

def @redrum.go time
  play(36, 0.5.beats)
  loop_at(next_beat, :go) if self.repeat
end

@redrum.start(next_beat, :go)

@redrum.stop

@test = i(@midi, 15)

def @test.go time
  dur = 1.bar
  16.times{|i| play_at(time + (i/4.0).beats, 48,0.25.beat)}
  loop_at(time + dur, :go) if self.repeat
end

@test.start(next_beat, :go)

@test.stop

exit
