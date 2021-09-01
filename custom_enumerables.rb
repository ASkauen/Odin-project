module Enumerable
  def my_each
      if block_given?
        for item in self
          yield(item)
        end
      else
        to_enum(:my_each)
      end
  end

  def my_each_with_index
    if block_given?
      index = 0
      for item in self
        yield(item, index)
        index += 1
      end
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    is_hash = self.is_a?(Hash)
    out = is_hash? ? {} : []
    if block_given?
      self.my_each do |item|
        out.push(item) if yield(item)
      end
      out
    else
      to_enum(:my_select)
    end
  end

  def my_all?
    if block_given?
      self.my_each {|i| return false unless yield(i)}
      true
    else
      self.my_each {|i| return false unless i}
      true
    end
  end

  def my_any?
    if block_given?
      self.my_each {|i| return true if yield(i)}
      false
    else
      self.my_each {|i| return true if i}
      false
    end
  end

  def my_none?
    if block_given?
      self.my_each {|i| return false if yield(i)}
      true
    else
      self.my_each {|i| return false if i}
      true
    end
  end

  def my_count(*arg)
    out = 0

    if arg
      self.my_each {|i| out += 1 if i == arg[0]}
      warn "#{__FILE__}:#{__LINE__}: warning: block given but not used" if block_given?
    elsif block_given?
      self.my_each {|i| out += 1 if yield(i)}
    else
      self.my_each {|i| out += 1}
    end
    out
  end

  def my_map
    out = []
    if block_given?
      self.my_each {|i| out.push(yield(i))}
      out
    else
      to_enum(:my_map)
    end
  end

  def my_inject
    
  end
end

