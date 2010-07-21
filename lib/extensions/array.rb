class Array
  def shuffle
    self.sort_by{rand}
  end

  def choose
    self[rand(self.size)]
  end

  def wchoose probability_array
    raise "Probability array must contain #{self.size} elements" unless probability_array.size == self.size
    accumulator = 0
    number = rand * probability_array.inject(0) { |mem, e| mem + e }
    self.zip(probability_array.map{|p| accumulator += p}).find{|a| number <= a[1]}[0]
  end
end
