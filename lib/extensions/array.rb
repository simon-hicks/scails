class Array
  def shuffle
    self.sort_by{rand}
  end

  def choose
    self[rand(self.size)]
  end

  def wchoose probability_array
    raise "Probability array must contain #{self.size} elements" unless probability_array.size == self.size
    raise "Probabilities must add up to 1.00" unless probability_array.inject(0){|m,p| m + p}
    accumulator = 0
    number = rand
    self.zip(probability_array.map{|p| accumulator += p}).find{|a| number <= a[1]}[0]
  end
end
