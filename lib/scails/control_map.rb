class Scails::ControlMap
  def initialize hash
    @hash = {}
    hash.each do |k,v|
      add_branch(k,v)
    end
  end

  def add_branch key, value
    if value.is_a? Integer
      @hash[key] = value
    else
      @hash[key] = self.new(value)
    end
  end

  def method_missing method, *args
    if @hash.has_key? method
      @hash[method]
    else
      super method, *args
    end
  end
end
