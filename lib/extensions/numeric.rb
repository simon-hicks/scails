class Numeric
  def to_roman
    raise "Roman numeral conversion only works for integers less than 10." unless self.is_a?(Integer) && self < 10
    {
      1 => 'i',
      2 => 'ii',
      3 => 'iii',
      4 => 'iv',
      5 => 'v',
      6 => 'vi',
      7 => 'vii',
      8 => 'viii',
      9 => 'ix'
    }[self]
  end

  def cps_midi
    69.0 + 12.0 * (Math.log(self.to_f/440)/Math.log(2))
  end

  def midi_cps
    440.0 * (2.0 ** ((self.to_f - 69) / 12))
  end

  def beat beats_per_bar = nil
    beats_per_bar ||= Scails::Metronome.instance.beats_per_bar
    self.to_f/(beats_per_bar * tempo(:bars_per_second))
  end

  alias beats beat

  def bar
    self.to_f/tempo(:bars_per_second)
  end

  alias bars bar

  def octave
    self * 12
  end
  
  alias octaves octave
end

