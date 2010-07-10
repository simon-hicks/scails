class Scails::Rhythm
  def self.make_group *rhythms
    durs = []
    [rhythms].flatten.each do |r|
      durs << [r.beats_per_bar, r.durs]
    end
    time_sigs = durs.map{|a| a[0]}
    biggest = time_sigs.max
    beats_per_bar = biggest
    until time_sigs.map{|t| (beats_per_bar % t) == 0}.inject(true){|mem, bool| bool && mem}
      beats_per_bar += biggest
    end
    durs.map! do |t,a| 
      a.map{|dur| dur * (beats_per_bar / t)}
    end.flatten
    self.new(beats_per_bar, durs)
  end

  def initialize beats_per_bar, *durs
    @beats_per_bar = beats_per_bar
    @durs = [durs].flatten
  end

  attr_accessor :beats_per_bar, :durs

  include Enumerable

  def each &block
    @durs.each do |d|
      yield d.beats(@beats_per_bar)
    end
  end

  def each_with_index &block
    @durs.each_with_index do |d,i|
      yield d.beats(@beats_per_bar), i
    end
  end

  def [] index
    @durs[index].beats(@beats_per_bar)
  end

  def []= index, value
    @durs[index] = value
  end

  def to_s
    "r(#{@beats_per_bar},[#{@durs.join ','}])"
  end

  def inspect
    to_s
  end

  def size
    @durs.size
  end

  def length units = :bars
    @durs.inject(0){|m,b| m += b} * case units
    when :bars
      (1.0/@beats_per_bar)
    when :beats
      1.0
    when :seconds
      1.0/(@beats_per_bar * tempo(:bars_per_second))
    end
  end
end
