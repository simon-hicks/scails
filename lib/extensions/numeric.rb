class Numeric
  def cps_midi
    69.0 + 12.0 * (Math.log(self.to_f/440)/Math.log(2))
  end

  def midi_cps
    440.0 * (2.0 ** ((self.to_f - 69) / 12))
  end

  def beat beats_per_bar = nil
    beats_per_bar ||= Metronome.instance.beats_per_bar
    self.to_f/(beats_per_bar * tempo(:bars_per_second))
  end

  alias beats beat

  def bar
    self.to_f/tempo(:bars_per_second)
  end

  alias bars bar
end

