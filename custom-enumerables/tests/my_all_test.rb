# frozen_string_literal: true

require_relative '../enum_methods'
arr = [1, 2, 3, 4]
hsh = { a: 1, b: 2, c: 3 }
puts '==: my_all?'
p arr.my_all? { |el| el.instance_of?(Integer) }
p arr.my_all? { |el| el < 4 }
p hsh.my_all? { |_k, v| v.positive? }
p arr.my_all?
p arr.my_all?(Integer)
p arr.my_all?(String)
puts '==: all?'
p arr.all? { |el| el.instance_of?(Integer) }
p arr.all? { |el| el < 4 }
p hsh.all? { |_k, v| v.positive? }
p arr.all?
p arr.all?(Integer)
p arr.all?(String)
