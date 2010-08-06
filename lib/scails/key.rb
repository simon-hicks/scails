class Scails::Key
  include Scails::Constants

  def initialize string
    @name = string.capitalize
    @tonic = PITCH_LETTER_TO_NUMBER[@name[0..-4].upcase]
    @intervals = SCALES[string[-3,3].downcase]
  end

  attr_reader :tonic, :name

  def to_s
    @name
  end

  def inspect
    @name
  end

  def scale octave = 4
    @intervals.map{|p| p + @tonic + (12 * octave) + 12}
  end

  # returns the note at the given degree in the scale. If the degree is higher than the number of tones in the scale, then the degree is taken from a higher octave
  def at degree
    raise "Degree must be 1 or greater... there is no degree 0!" if degree.to_i == 0
    if degree.respond_to? :match
      accidental = degree.match(/b/) ? -1 : 0
      accidental = degree.match(/#/) ? 1 : accidental
    else
      accidental = 0
    end
    index = degree.to_i - 1
    octave = index / @intervals.size
    @intervals[(index % @intervals.size)] + (octave * 12) + @tonic + accidental
  end

  # returns an array of degrees that are consonant with degree
  def consonant_degrees degree
    [perfect_degrees(degree), imperfect_degrees(degree)].flatten
  end

  # returns an array of degrees that are perfectly consonant with degree
  def perfect_degrees degree
    # remember: a fourth from degree is (degree + 3)
    candidates = [degree - 4, degree - 3, degree + 3, degree + 4].reject{|d| d < 1}
    perfect = candidates.select{ |cd| [-7, -5, 5, 7].include?(at(cd) - at(degree)) }
    perfect << degree + 7 << degree - 7
    perfect.reject{|d| d < 1}
  end

  # returns an array of degrees that are imperfectly consonant with degree
  def imperfect_degrees degree
    # remember: a third from degree is (degree + 2)
    candidates = [degree - 5, degree - 2, degree + 2, degree + 5].reject{|d| d < 1}
    imperfect = candidates.select{ |cd| [-9, -8, -4, -3, 3, 4, 8, 9].include?(at(cd) - at(degree))}
  end

  # returns the degree number for a given tone in the scale. if the tone doesn't match, then the degree is returned with an accidental. degrees count continuously up from zero, so notes above the 1st octave will have degrees above 7
  def get_degree note
    relative_note = note - @tonic # we are only concerned with the note relative to the tonic
    octave = (relative_note.to_i / 12) - 1
    index = @intervals.index(@intervals.find{|n| n >= relative_note % 12})
    return "#{((octave + 1) * @intervals.size) + 7}#" unless index # if index is nil, it means note is a sharpened 7th index... we add 1 to octave to account for the -1st octave
    degree = index + 1
    approximate_degree = ((octave + 1) * 7) + degree
    accidental = ACCIDENTALS[relative_note - (((octave + 1) * 12) + @intervals[index])]
    return "#{approximate_degree}#{accidental}"
  end

  # returns a new Key object, transposed up by the given number of semitones
  def transpose semitones
    new_key = @name.clone
    new_key[0..-4] = PITCH_TO_LETTER[(@tonic + semitones) % 12].first
    Key.new(new_key)
  end

  def + semitones
    self.transpose semitones
  end

  def - semitones
    self.transpose(semitones * -1)
  end

  #def chord chord_name
    #root_degree, chord = parse_chord(chord_name)
    #root = @tonic + (root_degree -1)
    #if chord
      #chord.map{|n| n + root}
    #else
      #default_chord(root_degree)
    #end
  #end
  
  #private

  #def parse_chord name
    #md = /([vViI]{1,3})(.*)?/.match(name)
    #root_degree = NUMERALS[md[1].upcase] 
    #chord = md[2] && CHORDS[md[2]]
    #return root_degree, chord
  #end

  #def default_chord degree
    #degrees = [degree,degree + 2, degree + 4].map{|d| d % 12}
    #degrees.map{|d| this_scale = self.scale(-1); this_scale[ (d - 1) % this_scale.size] }
  #end
end
