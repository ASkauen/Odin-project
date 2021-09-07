# frozen_string_literal: true

require_relative '../enum_methods'

def multiply_els(arr)
  arr.my_inject(:*)
end

arr = [1, 2, 3]
arr2 = [2, 4, 5]
hsh = { a: 1, b: 2, c: 3 }
puts '==: #my_inject'
p arr.my_inject { |sum, n| sum + n }
p arr.my_inject(3) { |sum, n| sum + n }
p hsh.my_inject(0) { |sum, (_k, v)| sum + v }
p arr.my_inject(:+)
p arr.my_inject(3, :*)
puts '==: #multiply_els'
p multiply_els(arr2)
puts '==: #inject'
p arr.inject { |sum, n| sum + n }
p arr.inject(3) { |sum, n| sum + n }
p hsh.inject(0) { |sum, (_k, v)| sum + v }
p arr.inject(:+)
p arr.inject(3, :*)
