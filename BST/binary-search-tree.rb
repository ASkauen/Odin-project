require 'pry'

class Node
  attr_accessor :left_child, :right_child, :data

  def initialize(data)
    @data = data
    @left_child = nil
    @right_child = nil

  end
end

class Tree
  attr_reader :root

  def initialize(array)
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(arr, start = 0, end_i = arr.uniq.size - 1)
    return nil if start > end_i
    middle = (start + end_i) / 2
    root = Node.new(arr[middle])
    root.left_child = build_tree(arr, start, middle - 1)
    root.right_child = build_tree(arr, middle + 1, end_i)
    root
  end

  def inorder(node = @root, array = [])
    inorder(node.left_child, array) if node.left_child
    array << node.data
    inorder(node.right_child, array) if node.right_child
    array
  end

  def preorder(node = @root, array = [])
    array << node.data
    preorder(node.left_child, array) if node.left_child
    preorder(node.right_child, array) if node.right_child
    array
  end

  def postorder(node = @root, array = [])
    postorder(node.left_child, array) if node.left_child
    postorder(node.right_child, array) if node.right_child
    array << node.data
    array
  end

  def levelorder(node = @root, array = [], queue = [node])
    return if queue.empty?

    array << node.data
    queue << node.left_child if node.left_child
    queue << node.right_child if node.right_child
    queue.shift
    levelorder(queue[0], array, queue)
    array
  end

  def insert(value, node = @root)
    if node.data > value
      if node.left_child.nil?
        new_node = Node.new(value)
        node.left_child = new_node
      end
      insert(value, node.left_child)
    elsif node.data < value
      if node.right_child.nil?
        new_node = Node.new(value)
        node.right_child = new_node
      end
      insert(value, node.right_child)
    else
      return
    end
  end

  def set_l_r_child(parent, which_child, replacement)
    if parent  
      case which_child
      when "left"
        parent.left_child = replacement
      when "right"
        parent.right_child = replacement
      end
    else
      @root = replacement
    end
  end

  def del_node_w_children(node, parent, which_child)
    right = node.right_child
    left = node.left_child
    right_has_left_child = right.left_child.nil? ? false : true
    if right_has_left_child
      stack = []
      current_node = right
      until current_node.nil?
        stack.append(current_node)
        current_node = current_node.left_child
      end

      replacement = stack[-1]
      r_parent = stack[-2]
      r_parent.left_child = replacement.right_child
      p stack.map {|n| n.data}
      set_l_r_child(parent, which_child, replacement)
      replacement.left_child = left
      replacement.right_child = right
    else
      set_l_r_child(parent, which_child, right)
      right.left_child = left
    end
  end

  def delete(value, node = @root, parent = nil, which_child = nil)
    is_leaf_node = node.left_child || node.right_child ? false : true
    has_single_child = node.left_child.nil? ^ node.right_child.nil? ? true : false
    if value < node.data
      delete(value, node.left_child, node, "left")
    elsif value > node.data
      delete(value, node.right_child, node, "right")
    else
      if is_leaf_node
        set_l_r_child(parent, which_child, nil)
      elsif has_single_child

        child = node.left_child.nil? ? node.right_child : node.left_child
        set_l_r_child(parent, which_child, child)
      else
        del_node_w_children(node, parent, which_child)
      end
    end
  end

  def find(value, node = @root)
    return node if value == node.data

    if value > node.data
      find(value, node.right_child) if node.right_child
    else
      find(value, node.left_child) if node.left_child
    end
  end

  def height(node, step = 0, max_steps = 0)
    max_steps = step if step > max_steps
    max_steps = height(node.left_child, step += 1, max_steps) if node.left_child
    step -= 1 if node.left_child
    max_steps = height(node.right_child, step += 1, max_steps) if node.right_child
    max_steps
  end

  def depth(node, current_node = @root, step = 0, max = 0)
    max = step if step > max
    if node.data < current_node.data
      max = depth(node, current_node.left_child, step += 1, max)
    elsif node.data > current_node.data
      max = depth(node, current_node.right_child, step += 1, max) 
    end
    max
  end

  def balanced?(node = @root)
    return unless node.left_child || node.right_child

    left_height = node.left_child ? height(node.left_child) + 1 : 0
    right_height = node.right_child ? height(node.right_child) + 1 : 0
    balanced?(node.left_child) if node.left_child
    balanced?(node.right_child) if node.right_child

    return false if (left_height - right_height).abs > 1
    true
  end

  def rebalance()
    return puts "already balanced" if balanced?
    @root = build_tree(inorder)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end
