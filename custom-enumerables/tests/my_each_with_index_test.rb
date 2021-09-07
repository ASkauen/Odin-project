# frozen_string_literal: true

require_relative '../enum_methods'

arr = [1, 2, 3, 4, 5, 6]
my_hash = { a: 1, b: 2, c: 3 }
puts '==: #my_each_with_index'
arr.my_each_with_index { |el, idx| puts "#{el} is at index #{idx}" }
my_hash.my_each_with_index { |pair, idx| puts "#{pair} -> #{idx}" }
p arr.my_each_with_index
puts '==: #each_with_index'
arr.each_with_index { |el, idx| puts "#{el} is at index #{idx}" }
my_hash.each_with_index { |pair, idx| puts "#{pair} -> #{idx}" }
p arr.each_with_index
