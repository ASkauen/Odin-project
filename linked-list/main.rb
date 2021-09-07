# frozen_string_literal: true

require_relative 'linked-list'

my_list = LinkedList.new
puts my_list
my_list.append("1")
my_list.append("2")
my_list.append("3")
my_list.append("4")
my_list.append("5")
puts my_list
my_list.prepend("first")
puts my_list
puts "Size: #{my_list.size}"
puts "Head: #{my_list.head.data}"
puts "Tail: #{my_list.tail.data}"
puts "At 1: #{my_list.at(1).data}"
my_list.pop
puts my_list
puts "Contains 'first': #{my_list.contains?('first')}"
puts "Contains 'last': #{my_list.contains?('last')}"
puts "Index of 'first': #{my_list.find('first')}"
puts my_list
my_list.insert_at('new_first', 0)
my_list.insert_at('inserted', 1)
puts my_list
my_list.remove_at(2)
puts my_list
