# frozen_string_literal: true

require_relative '../enum_methods'

arr = [0, 1, 2, 2, 3]
hsh = { a: 1, b: 2, c: 2 }
puts '==: my_count'
puts arr.my_count
puts arr.my_count(2)
puts arr.my_count { |el| el > 1 }
puts hsh.my_count { |_, v| v == 2 }
puts '==: count'
puts arr.count
puts arr.count(2)
puts arr.count { |el| el > 1 }
puts hsh.count { |_, v| v == 2 }
