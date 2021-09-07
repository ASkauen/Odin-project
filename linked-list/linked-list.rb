# frozen_string_literal: true

class LinkedList
  def initialize
    @head = nil
    @tail = nil
  end

  def append(value)
    new_node = Node.new(value)
    @head ||= new_node
    if @tail
      @tail.next_node = new_node
    else
      @tail = new_node
    end
    @tail = new_node
  end

  def prepend(value)
    new_node = Node.new(value, @head)
    @head = new_node
  end

  def size
    count = 0
    current_node = @head
    until current_node.nil?
      count += 1
      current_node = current_node.next_node
    end
    count
  end

  attr_reader :head, :tail

  def at(index)
    node_at_index = @head
    index.times do
      return nil if node_at_index.nil?

      node_at_index = node_at_index.next_node
    end
    node_at_index
  end

  def pop
    if size() <= 1
      @head = @tail = nil
      return
    end
    second_last = at(size - 2)
    second_last.next_node = nil
    @tail = second_last
  end

  def contains?(value)
    current_node = @head
    until current_node.nil?
      return true if current_node.data == value

      current_node = current_node.next_node
    end
    false
  end

  def find(value)
    current_node = @head
    count = 0
    until current_node.nil?
      return count if current_node.data == value

      count += 1
      current_node = current_node.next_node
    end
    nil
  end

  def to_s
    str = ''
    current_node = @head

    until current_node.nil?
      str += "( #{current_node.data} ) -> "
      current_node = current_node.next_node
    end
    str += 'nil'
    str
  end

  def insert_at(value, index)
    if index.zero?
      new_node = Node.new(value, @head)
      @head = new_node
    elsif index == size() - 1
      new_node = Node.new(value, nil)
      @tail.next_node = new_node
      @tail = new_node
    else
      old_node = at(index)
      node_before = at(index - 1)
      new_node = Node.new(value, old_node)
      node_before.next_node = new_node
    end
  end

  def remove_at(index)
    node_after = at(index + 1)
    node_before = at(index - 1)
    if index.zero?
      @head = at(index + 1)
    elsif index == (size() - 1)
      node_before.next_node = nil
      @tail = node_before
    else
      node_before.next_node = node_after
    end
  end
end

class Node
  attr_accessor :data, :next_node

  def initialize(data = nil, next_node = nil)
    @data = data
    @next_node = next_node
  end
end
