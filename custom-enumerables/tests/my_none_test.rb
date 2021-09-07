# frozen_string_literal: true

require_relative '../enum_methods'

arr = [1, 2, 3, 'a']
hsh = { a: 1, b: 'a', c: true }

puts '==: my_none?'
puts arr.my_none?
puts arr.my_none?(String)
puts arr.my_none? { |el| el.to_i > 4 }
puts hsh.my_none? { |_k, v| v.to_s == 'false' }
puts hsh.my_none?
puts '==: none?'
puts arr.none?
puts arr.none?(String)
puts arr.none? { |el| el.to_i > 4 }
puts hsh.none? { |_k, v| v.to_s == 'false' }
puts hsh.none?
