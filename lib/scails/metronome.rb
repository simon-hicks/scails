class Scails::Metronome
  include Singleton

  attr_accessor :zero_time, :bars_per_second, :beats_per_bar

  def initialize
    @zero_time = Time.now.to_f
    @bars_per_second = 0.25
    @beats_per_bar = 4
  end

  def get_next_bar
    Time.at(@zero_time + ((((Time.now.to_f - @zero_time) * @bars_per_second).to_i + 1) / @bars_per_second))
  end

  def get_next_beat beats_per_bar = @beats_per_bar
    beats_per_second = @bars_per_second * beats_per_bar
    Time.at(@zero_time + ((((Time.now.to_f - @zero_time) * beats_per_second).to_i + 1) / beats_per_second))
  end

  def bars_per_second
    @bars_per_second
  end

  def bars_per_second= new_value
    now = Time.now.to_f
    @zero_time = now - ((now - @zero_time)*(@bars_per_second/new_value)) # this resets the @zero_point so that we've had the samenumber of bars since then at the new speed as we'd had with the old speed
    @bars_per_second = new_value
  end

  def bars_per_minute
    @bars_per_second * 60.0
  end

  def bars_per_minute= new_value
    bars_per_second=(new_value/60.0)
  end

  def self.method_missing name, *args
    self.instance.send(name, *args)
  end
end
