class Scails::Chord < Scails::PitchClass

  #############################################################
  ## This is a subclass of PitchClass designed for dealing with 
  ## jazz chords etc.
  ##
  ## It can be accessed using c(key, chord_type)
  ##
  #############################################################

  include Scails::Constants

  def initialize key, name
    @key = case key
           when Scails::Key
             key
           else
             Scails::Key.new(key)
           end
    @name = name
    super(self.get_notes)
  end
  
  attr_reader :key, :name

  # returns the scale that's best associated with this chord
  def scale
    root_degree, type = parse_chord @name
    scale_tonic = @key.scale[root_degree - 1]
    scale_mode = CHORDS_TO_SCALES[type]
    SCALES[scale_mode].map{|n| n + scale_tonic}
  end

  # returns the notes for the given chord (using @key)
  def get_notes chord_name = @name
    root_degree, type = parse_chord(chord_name)
    root = @key.at(root_degree)
    if type && !type.empty?
      CHORDS[type].map{|n| (n + root) % 12}
    else
      default_chord(root_degree)
    end
  end

  def to_s
    "c(#{@key}, #{@name})"
  end

  def inspect
    to_s
  end
  
  private

  def parse_chord name
    md = /([vViI]{1,3})(.*)?/.match(name)
    root_degree = NUMERALS[md[1].upcase]
    type = md[2]
    return root_degree, type
  end

  def default_chord degree
    degrees = [degree,degree + 2, degree + 4].map{|d| ((d - 1) % 7) + 1}
    chord = degrees.map{|d| @key.at(d)}
    @name = @name + chord_type(result = chord.map{|n| n % 12})
    result
  end

  def chord_type notes
    base_note = notes[0]
    CHORDS.find{|chord_type, note_array| note_array == notes.map{|n| (n - base_note) % 12} }[0]
  end
end
