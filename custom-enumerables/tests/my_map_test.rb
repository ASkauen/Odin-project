# frozen_string_literal: true

require_relative '../enum_methods'

arr = [1, 2, 3]
hsh = { a: 2, b: 'hello', c: 3 }
a_proc = proc { |el| el * 4 }
puts '==: #my_map'
p arr.my_map
p arr.my_map { |el| el * 3 }
p hsh.my_map { |_, v| v * 2 }
puts '==: #my_map with proc compatibility'
p arr.my_map(a_proc)
p arr.my_map(a_proc) { puts "it didn't work" }
puts '==: #map'
p arr.my_map
p arr.my_map { |el| el * 3 }
p hsh.my_map { |_, v| v * 2 }
