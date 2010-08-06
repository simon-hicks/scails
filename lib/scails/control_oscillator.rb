class Scails::ControlOscillator
  def initialize options, block
    @proc = block
    @amp = options[:amp]||options[:amplitude]
    @freq = options[:freq]||options[:frequency]
    @tick = options[:tick]||options[:tick_size]
    @generator = create_generator_proc(options[:shape])
    @stop = false
  end

  def go
    @start_time = now
    @stop = false
    recurse(@start_time)
  end

  def stop
    @stop = true
    nil
  end

  private

  def recurse time
    @proc.call(@generator.call(time - @start_time))
    Scails::Clock.instance.at(time + @tick) {|t| recurse(t)} unless @stop
  end

  def create_generator_proc shape
    return case shape
    when :sin
      proc{|x| sinr(x, @freq) * @amp}
    when :cos
      proc{|x| cosr(x, @freq) * @amp}
    when :saw
      proc{|x| sawr(x, @freq) * @amp}
    when :triangle
      proc{|x| trir(x, @freq) * @amp}
    when :square
      proc{|x| squr(x, @freq) * @amp}
    end
  end
end
