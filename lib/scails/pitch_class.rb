class Scails::PitchClass < Array
  ######################################################################
  ##
  ## A class for working with pitch class sets
  ##
  ## A pitch class in this library is taken to be a
  ## list of MIDI note values from the first octave (0-11)
  ## from which other pitches are compared using modulo 12.
  ## Therefore, 0 = C, 1 = C#, etc..
  ##
  ## an argument refered to as a 'pitch' is from the first octave,
  ## while a note can be from anywhere on the keyboard
  ##
  ######################################################################
  
  alias old_include? include?

  # checks if self includes pitch (ie. pc(0,4,7).include? 60 # => true)
  def include? pitch
    self.old_include?(pitch % 12)
  end

  alias old_plus +

  # redefine + so we can simply add a numeric to transpose the pitch class without quantizing
  def + object
    case object
    when Numeric
      return self.map{|n| n + object}
    else
      return self.old_plus object
    end
  end

  alias old_minus -

  # redefine - so we can simply subtract a numeric to transpose the pitch class without quantizing
  def - object
    case object
    when Numeric
      return self.map{|n| n - object}
    else
      return self.old_minus object
    end
  end

  # returns the closest member pitch (or array of pitches) to the given arg 'pitch'. Normally, quantize prefers the higher note. Passing :down as the second paramchanges this behaviour
  def quantize pitch, direction = :up
    case 
    when pitch.respond_to?(:map)
      forbidden = []
      return pitch.map do |p| 
        quantized_note = self.single_quantize(p, direction, forbidden)
        forbidden << quantized_note
        quantized_note
      end.compact
    end
    return self.single_quantize pitch, direction
  end

  # returns a random member pitch between lower to upper
  def random lower, upper
    50.times do
      pitch = (rand(upper - lower) + lower)
      return pitch if self.include? pitch
    end
  end

  # returns the member of self that is 'interval' steps of self above bass
  # eg.
  #
  # pc(0,2,4,5,7,9,11).relative(60, 3)
  # => 64
  # pc(0,2,4,5,7,9,11).relative(60, 19)
  # => 91
  def relative bass, interval
    interval = interval - 1 # this is to account for the fact that intervals start at 1, not 0
    octaves = (interval / self.size).to_i
    steps = interval % self.size
    bass + (12 * octaves) + self[steps]
  end

  # returns a randomised chord using only members of self. the chord is evenly distributed between lower and upper
  def chord lower, upper, number
    # split full range into equal sized chunks
    range = upper - lower
    gap = (range / number).to_i
    # choose one note from each chunk
    chord = []
    (number - 1).times do |i|
      l = lower + (i * gap)
      u = l + gap - 1
      chord << self.random(l, u) || self.random(lower,upper)
    end
    chord << self.random(lower + ((number - 1) * gap), upper) || self.random(lower, upper)
    # remove any remaining nils
    chord.uniq.compact.sort
  end

  # returns the degree of the given pitch within self
  def degree pitch
    index_of_pitch = self.index(pitch%12)
    index_of_pitch && index_of_pitch + 1
  end

  # inverts the intervals of all elements in list relative to the first element of list and then quantizes the resulting list to self
  def invert list
    first = list[0]
    self.quantize(list.map{|p| first + (first - p)})
  end

  # transposes the pitches in list by 'interval' semitones and then quantizes them
  def transpose_list list, interval
    self.quantize(list.map{|p| p + interval})
  end

  # expands the intervals of all elements in list relative to the first element of list and then quantizes the resulting list to self
  def expand list, factor
    first = list[0]
    self.quantize(list.map{|p| first + (2 * (p - first))})
  end

  #def chord_options root, mood
    #symbols = ([:major, 'major'].include?(mood) ? major_chord_option_symbols(root) : minor_chord_option_symbols(root))
    #symbols.map{ |sym| self.class.chord(root, sym)}
  #end

  # for a single pitch returns the distance from the nearest member of self. for a collection of notes, it returns the cumulative value of the same.
  def distance pitch
    case
    when pitch.respond_to?(:map)
      pitch.map{|p| single_distance(p)}.inject{|m, d| m+d}
    else
      single_distance pitch
    end
  end

  # returns the pitch within pitches that is closest to a member of self
  def closest *pitches
    pitch_list = [pitches].flatten.sort
    pitch_list.map! do |p|
      [distance(p), p]
    end
    pitch_list.sort_by{|a| a[0]}[0][1]
  end

  # returns the inversion of chord which is closest to pc. Direction defines whether upward movement or downward movement is prefered and should be either :up or :down
  def move_chord direction, *chord
    chord = [chord].flatten
    members = self.to_a
    result = []
    until chord.empty?
      members = self.to_a if members.empty?
      p = pc(*members)
      match = p.closest(chord)
      result << (new_note = p.quantize(match, direction))
      members.slice!(members.index(new_note % 12))
      chord.slice!(chord.index(match))
    end
    result.sort
  end

  def to_s
    "pc(#{self.join(',')})"
  end

  def inspect
    to_s
  end

  protected

  # returns the note that is a member of self and is closest to 'pitch'. prefers a higher value if :up is given or a lower value if :down is given
  def single_quantize pitch, direction, forbidden_pitches = []
    0.upto(7) do |i|
      return pitch+i if direction == :up && (self.include?(pitch + i) &! forbidden_pitches.include?(pitch + i))
      return pitch-i if self.include?(pitch - i) &! forbidden_pitches.include?(pitch - i)
      return pitch+i if direction == :down && (self.include?(pitch + i) &! forbidden_pitches.include?(pitch + i))
    end
    nil
  end

  # returns the distance of a single pitch from the nearest member of self
  def single_distance pitch
    p = pitch % 12
    self.map do |c|
      val = p - c
      (val < (12 - val) ? val : (12 - val)).abs
    end.min
  end

  #def major_chord_option_symbols root
    #case self.degree(root)
    #when nil
      #return nil
    #when 1, 4
      #return %w(^ ^7 ^sus ^9 ^7#4)
    #when 2, 3, 6
      #return %w(- -7 -sus -9)
    #when 5
      #return %w(^ 7 ^sus 9)
    #when 7
      #return %w(o -7b5 o7)
    #end
  #end

  #def minor_chord_option_symbols root
    #case self.degree(root)
    #when nil
      #return nil
    #when 1, 4, 6
      #return %w(- -7 -sus -9)
    #when 2
      #return %w(o -7b5 o7)
    #when 3
      #return %w(^ ^7 ^sus ^9 ^7#4)
    #when 5
      #return %w(- -7 -sus -9 ^ 7 ^sus 9)
    #when 7
      #return %w(^ 7 ^sus 9 o -7b5 o7)
    #end
  #end
end
