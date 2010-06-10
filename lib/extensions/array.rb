
class Array
  alias old_plus +
  def + object
    if object.is_a? Numeric
      self.map{|n| n+ object}
    else
      old_plus object
    end
  end
end
