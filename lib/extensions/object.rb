class Object
  # Outputs an ANSI colored string with the object representation
  def to_live_output
    case self
    when Exception
      "\e[41m\e[33m#{self.inspect}\e[0m"
    when Numeric, Symbol, TrueClass, FalseClass, NilClass
      "\e[35m#{self.inspect}\e[0m"
    when Scails::Live::Notice
      "\e[42m\e[30m#{self}\e[0m"
    when Scails::Live::Warning
      "\e[43m\e[30m#{self}\e[0m"
    when Scails::Live::Special
      "\e[44m\e[37m#{self}\e[0m"
    when String
      "\e[32m#{self.inspect}\e[0m"
    when Array
      "[#{ self.collect{ |i| i.to_live_output}.join(', ') }]"
    when Hash
      "{#{ self.collect{ |i| i.collect{|e| e.to_live_output}.join(' => ') }.join(', ') }}"
    else
      "\e[36m#{self}\e[0m"
    end
  end
end

