class Scails::Motive
  def self.make_group *motives
    degrees = []
    [motives].flatten.each do |m|
      degrees << m.degrees
    end
    self.new(degrees)
  end

  def initialize *degrees
    @degrees = [degrees].flatten
  end

  attr_reader :degrees

  # yields each absolute note in the motive in turn using the given key, or yields the degrees themselves if no key is given
  def each key = nil
    if key
      key = key.is_a?(Scails::Key) ? key : Scails::Key.new(key)
      @degrees.each{|d| yield(key.at(d))}
    else
      @degrees.each{|d| yield d }
    end
  end

  # passes each degree to the block in turn and uses the resulting collection of notes to construct a new motive object
  def map &block
    new_degrees = @degrees.map &block
    self.class.new(new_degrees)
  end

  # passes each degree in the motive to the block in turn and changes self to match the returned values
  def map! &block
    @degrees.map!{ |n| block.call(n) }
    self
  end

  # returns the degree at the given index
  def [] index
    @degrees[index]
  end

  # changes the degree at the given index to 'value'
  def []= index, value
    @degrees[index] = value
  end

  def to_s
    "m(#{@degrees.join(', ')})"
  end

  def inspect
    to_s
  end
  
  # returns an array of the absolute notes in self using the given key
  def notes key
    key = key.is_a?(Scails::Key) ? key : Scails::Key.new(key)
    @degrees.map{|d| key.at(d)}
  end

  # appends the given degree to the motive.
  def << degree
    @degrees << degree
    self
  end

  # removes the last note from the motive and returns it as an absolute note value using the given key. If no key is given the degree is returned instead
  def pop key = nil
    value = @degrees.pop
    return_value_using_key value, key
  end

  # removes the first note from the motive and returns it as an absolute note value using the given key. If no key is given the degree is returned instead
  def shift key = nil
    value = @degrees.shift
    return_value_using_key value, key
  end

  # prepends the given degree to the motive.
  def unshift degree
    @degrees.unshift degree
    self
  end

  # returns a new motive object with the degrees reversed
  def reverse
    self.class.new(@degrees.reverse)
  end

  alias retrograde reverse

  # returns a new melody object constructed by inverting the steps from one note to the next. any accidentals are also inverted (ie. a '#' becomes a 'b')
  def invert
    approximate_steps = [] # get list of approximate steps
    @degrees.each_cons(2){|a,b| approximate_steps << (b.to_i - a.to_i)}
    adjustments = [] # get list of adjustments (ie. '+' if the step is an augmented interval, '++' if the step is double augmented etc.)
    @degrees.each_cons(2) do |a,b|
      adjustments << case a
      when /#/
        case b
        when /#/
          ''
        when /b/
          a.to_i > b.to_i ? '++' : '--'
        else
          a.to_i > b.to_i ? '+' : '-'
        end
      when /b/
        case b
        when /#/
          a.to_i > b.to_i ? '--' : '++'
        when /b/
          ''
        else
          a.to_i > b.to_i ? '-' : '+'
        end
      else
        case b
        when /#/
          a.to_i > b.to_i ? '-' : '+'
        when /b/
          a.to_i > b.to_i ? '+' : '-'
        else
          ''
        end
      end
    end
    adjusted_steps = [] # invert approximate steps and add adjustments
    approximate_steps.size.times do |i|
      if md = adjustments[i].match(/--|\+\+/)
        md[0] == '--' ? approximate_steps[i] -= 1 : approximate_steps[i] += 1
        adjustments[i] = ''
      end
      adjusted_steps[i] = (-1 * approximate_steps[i]).to_s + adjustments[i]
    end
    # construct new Motive object from inverted steps
    new_degrees = [@degrees[0]]
    adjusted_steps.each do |s|
      next_degree = apply_adjusted_step(new_degrees.last, s)
      new_degrees << next_degree
    end
    Motive.new(new_degrees)
  end

  private

  def return_value_using_key value, key
    if key
      key = key.is_a?(Scails::Key) ? key : Scails::Key.new(key)
      key.at(value)
    else
      value
    end
  end


  def apply_adjusted_step last_degree, step
    md = step.match(/(-)?(\d+)(\+|-)?/)
    operator = md[1] ? :- : :+
    existing_accidental = last_degree[/#|b/] || ''
    extra_accidental = md[3].nil? ? '' : case md[3]
    when '+'
      operator == :- ? 'b' : '#'
    when '-'
      operator == :+ ? 'b' : '#'
    end
    approximate_new_degree = last_degree.to_i.send(operator, md[2].to_i)
    total_new_accidental = extra_accidental + existing_accidental
    return case total_new_accidental
    when '##'
      (approximate_new_degree + 1).to_s
    when 'bb'
      (approximate_new_degree - 1).to_s
    when 'b#', '#b'
      approximate_new_degree.to_s
    else
      approximate_new_degree.to_s + total_new_accidental
    end
  end
end
