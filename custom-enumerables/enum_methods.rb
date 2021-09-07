module Enumerable
  def my_each(&block)
    if block_given?
      each(&block)
    else
      to_enum(:my_each)
    end
  end

  def my_each_with_index
    if block_given?
      index = 0
      my_each do |item|
        yield(item, index)
        index += 1
      end
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    is_hash = is_a?(Hash)
    out = is_hash ? {} : []
    if block_given?
      my_each do |item|
        if yield(item)
          is_hash ? out.store(item[0], item[1]) : out.push(item)
        end
      end
      out
    else
      to_enum(:my_select)
    end
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |i| return false unless yield(i) }
    elsif arg
      my_each { |i| return false unless arg === i }
    else
      my_each { |i| return false unless i }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |i| return true if yield(i) }
    elsif arg
      my_each { |i| return true if arg === i }
    else
      my_each { |i| return true if i }
    end
    false
  end

  def my_none?(*arg)
    if !arg.empty?
      my_each { |i| return false if arg[0] === i }
    elsif block_given?
      my_each { |i| return false if yield(i) }
    else
      my_each { |i| return false if i }
    end
    true
  end

  def my_count(*arg)
    out = 0

    if !arg.empty?
      my_each { |i| out += 1 if i == arg[0] }
      warn "#{__FILE__}:#{__LINE__}: warning: block given but not used" if block_given?
    elsif block_given?
      my_each { |i| out += 1 if yield(i) }
    else
      my_each { out += 1 }
    end
    out
  end

  def my_map(proc = nil)
    out = []
    if proc
      my_each { |i| out.push(proc.call(i)) }
    elsif block_given?
      my_each { |i| out.push(yield(i)) }
      out
    else
      to_enum(:my_map)
    end
  end

  def my_inject(initial = nil, symbol = nil)
    if initial.instance_of?(Symbol)
      symbol = initial
      initial = nil
    end

    accum = initial || self[0]
    shift = is_a?(Hash) ? slice(keys[1], keys[-1]) : self[1..-1]
    sym_block = ->(el) { accum = accum.send(symbol, el) }
    standard_block = ->(el) { accum = yield accum, el }

    if symbol && initial
      my_each(&sym_block)
    elsif initial
      my_each(&standard_block)
    elsif symbol
      shift.my_each(&sym_block)
    else
      shift.my_each(&standard_block)
    end
    accum
  end
end
