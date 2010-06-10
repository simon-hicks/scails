@dls = Scails::MIDIator::Interface.new
@dls.use :dls_synth
set_tempo(0.5, :bars_per_second)

@left = Scails::Instrument.new(@dls, 0) 
@right = Scails::Instrument.new(@dls, 1) 


@left.play 60, 0.5.beat
@right.play 60, 0.5.beat


def @left.seconds time
  seconds = [0,2,4,5,7,9,11,12].zip([2,4,5,7,9,11,12,14])
  seconds.each_with_index do |c,i|
    Scails::Clock.instance.at(time + i.beats) { |t| self.play c.map{|n| n+60}, 0.5.beats }
  end
  at time + 2.bar, :seconds
end

def @left.sevenths time
  sevenths = [0,2,4,5,7,9,11,12].zip([11,12,14,16,17,19,21,23])
  sevenths.each_with_index do |c,i|
    Scails::Clock.instance.at(time + i.beats) { |t| self.play c.map{|n| n+60}, 0.5.beats }
  end
  at time + 2.bar, :sevenths
end

def @left.fifths time
  fifths = [0,2,4,5,7,9,11,12].zip([7,9,11,12,14,16,17,19])
  fifths.each_with_index do |c,i|
    Scails::Clock.instance.at(time + i.beats) { |t| self.play c.map{|n| n+60}, 0.5.beats }
  end
  at time + 2.bar, :fifths
end

def @left.fourths time
  fourths = [0,2,4,5,7,9,11,12].zip([5,7,9,11,12,14,16,17])
  fourths.each_with_index do |c,i|
    Scails::Clock.instance.at(time + i.beats) { |t| self.play c.map{|n| n+60}, 0.5.beats }
  end
  at time + 2.bar, :fourths
end

def @left.thirds time
  thirds = [0,2,4,5,7,9,11,12].zip([4,5,7,9,11,12,14,16])
  thirds.each_with_index do |c,i|
    Scails::Clock.instance.at(time + i.beats) { |t| self.play c.map{|n| n+60}, 0.5.beats }
  end
  at time + 2.bar, :thirds
end

def @left.sixths time
  sixths = [0,2,4,5,7,9,11,12].zip([9,11,12,14,16,17,19,21])
  sixths.each_with_index do |c,i|
    Scails::Clock.instance.at(time + i.beats) { |t| self.play c.map{|n| n+60}, 0.5.beats }
  end
  at time + 2.bar, :sixths
end

@left.start(next_bar, :seconds)

@left.start(next_bar, :thirds)

@left.start(next_bar, :fourths)

@left.start(next_bar, :fifths)

@left.start(next_bar, :sixths)

@left.start(next_bar, :sevenths)

@left.stop 

I   = [0 ,4 ,7 ]
ii  = [2 ,5 ,9 ]
iii = [4 ,7 ,11]
IV  = [5 ,9 ,12]
V   = [7 ,11,14]
vi  = [9 ,12,16]
vii = [11,14,17]

@left.play I+60,1

@left.play I+61,1

@left.play I+62,1

@left.play I+63,1

@left.play I+64,1

@left.play I+65,1

@left.play I+66,1



class ::Array
  alias old_plus +
  def + object
    if object.is_a? Numeric
      self.map{|n| n+ object}
    else
      old_plus object
    end
  end
end
