@midi = Scails::MIDIator::Interface.new
@midi.autodetect_driver
set_tempo(0.5, :bars_per_second)
$key = k 'Cmaj'
@mixer = i(@midi, 4, :channel_1_level => 8,
                     :channel_2_level => 9,
                     :channel_3_level => 10,
                     :channel_4_level => 12,
                     :channel_5_level => 13,
                     :channel_6_level => 14,
                     :channel_7_level => 15,
                     :channel_8_level => 16,
                     :channel_9_level => 17)


# redrum defs
@redrum = i @midi, 0

def @redrum.beat time
  x = true
  _ = false
  dur = 1.bar
  tick = 0.25.beats
  tracks = {
    :kick => [36, [x,_,_,_,  x,_,_,_,  x,_,_,_,  x,_,_,_]],
    :hat => [38, [_,_,x,_,  _,_,_,x,  _,_,x,_,  _,x,_,_]],
    :perc => [40, [_,x,_,_,  _,_,_,_,  _,x,_,_,  _,_,_,x]]
  }
  tracks.values.each do |n, track|
    track.each_with_index{|v, i| play_at(time + (i*tick), n, tick) if v}
  end
  loop_at(time + dur, :beat) if self.repeat
end

# redrum controls
@redrum.start next_bar, :beat

@redrum.stop(next_bar + 1.bar)

@redrum = nil


# bass defs
@bass = i @midi, 1

def @bass.do time
  pattern = [[0,2,0], [0,0,0], [0,0,2]].wchoose([1,1,1])
  3.times do |i|
    play_at(time + ((i + 1)/4.0).beats, $chord.sort[pattern[i]] + 4.octaves, 0.25.beats)
  end
  loop_at(next_beat, :do) if self.repeat
end

# bass controls
control_ramp(now, 20, 120, 20){|v| @mixer.channel_2_level = v}
@bass.start(next_bar, :do)

control_ramp(now, 90, 0, 15){|v| @mixer.channel_2_level = v}
@bass.stop(now + 15)

@bass = nil


# lead defs
@lead = i @midi, 2, :expression => 1

def @lead.walk time, this_degree = 40
  dur = [0.25,0.5,1.0].choose.beat
  wait= [0.5,1,2].choose.beat
  play($key.at(this_degree), dur)
  unless this_degree > 55 || this_degree < 30
    next_degree = this_degree + [-2,-1,0,1,2].wchoose([0,3,1,3,0])
  else
    next_degree = 40
  end
  loop_at(time + wait, :walk, next_degree) if self.repeat
end

# lead controls
control_ramp(now, 10, 60, 20) {|v| @mixer.channel_3_level = v}
@lead.start next_beat(4), :walk

@lead_osc = control_osc(:amp => 127, :freq => 0.03, :tick => 0.2, :shape => :sin){|v| @lead.expression = v}
@lead_osc.go

control_ramp(now, 60, 10, 20) {|v| @mixer.channel_3_level = v}
@lead.stop(now + 20)

@lead = nil
@lead_osc = nil


# pad defs
@pad = i @midi, 3, :expression => 1

def @pad.chords time, chord = 'i'
  $chord = c($key, chord)
  play $chord + 4.octaves, 4.bar
  next_chord = {
    'i'     => ['iv','iii'],
    'iv'    => ['i'],
    'iii'   => ['iv', 'v'],
    'v'    => ['iii']
  }[chord].choose
  loop_at(time + 4.bar, :chords, next_chord) if self.repeat
end

# pad controls
@pad.start next_bar, :chords

@pad_osc = control_osc(:amp => 127, :freq => 0.1, :tick => 0.2, :shape => :sin){|v| @pad.expression = v}
@pad_osc.go

@pad.stop

@pad = nil
@pad_osc = nil


# synth defs
@synth = i @midi, 5, :expression => 1

def @synth.stab time
  hits_per_bar = 3
  steps = 8
  dur = 1.bar
  steps.times do |i|
    play_at(time + (i * dur/steps), $chord.max + [2,3,4].choose.octaves, 0.25.beats) if rand < hits_per_bar/steps.to_f
  end
  loop_at(time + dur, :stab) if self.repeat
end

# synth controls
@pad.start next_bar, :chords
control_ramp(now, 40, 127, 20){|v| @mixer.channel_6_level = v}
@synth.start(next_bar, :stab)

@synth_osc = control_osc(:amp => 127, :freq => 0.1, :tick => 0.1, :shape => :sin){|v| @synth.expression = v}
@synth_osc.go

control_ramp(now, 127, 40, 20){|v| @mixer.channel_6_level = v}
@synth.stop(now + 20)

@synth = nil

@synth_osc = nil


# soft_perc defs
@soft_perc = i @midi, 6

def @soft_perc.arp time, patterns = {}
  num = $chord.size
  pattern = (patterns[$chord] ||= (0..(num-1)).to_a.shuffle)
  tick = (1.0 / num)
  (4 * $chord.size).times do |i|
    index = i % num
    play_at(time + (i * tick.beats), $chord[pattern[index]] + 5.octaves, tick)
  end
  loop_at(time + 1.bar, :arp, patterns) if self.repeat
end

# soft_perc controls
@soft_perc.start next_bar, :arp

control_ramp(now, 70, 0, 15){|v|@mixer.channel_7_level = v}
@soft_perc.stop(now +16)

@soft_perc = nil


# smooth defs
@smooth = i(@midi, 8)

def @smooth.down time
  notes = $chord.chord(30, 60, 5).sort
  notes = notes.shuffle
  notes.each_with_index{|n, i| play_at(time + (i*0.5).beats, n+ 2.octave,0.26)}
  wait = 1.bar
  loop_at(time + wait, :down) if self.repeat
end

# smooth controls
@smooth.start(next_bar, :down)

control_ramp(now, 70, 0, 15){|v|@mixer.channel_9_level = v}
@smooth.stop(now + 16)

@smooth = nil


# squiggle defs
@squiggle = i(@midi, 7)

def @squiggle.do time
  wait = (rand(3) + 1).bars
  note = $chord.choose + 2.octaves
  dur = 2.beats
  play note, dur
  loop_at(time + wait, :do) if self.repeat
end

# squiggle controls
@squiggle.start(next_bar, :do)

@squiggle.stop

@squiggle = nil


exit
