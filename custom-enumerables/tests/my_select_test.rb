# frozen_string_literal: true

require_relative '../enum_methods'

arr = [1, 'hey', 3, 'what?', 5]
hsh = { a: 1, b: 2, c: 3 }
puts '==: my_select'
new_arr = arr.my_select { |el| el.instance_of?(String) }
new_hsh = hsh.my_select { |k, _v| %i[a b].include?(k) }
p hsh.my_select
p new_arr
p new_hsh
puts '==: select'
second_arr = arr.select { |el| el.instance_of?(String) }
second_hsh = hsh.select { |k, _v| %i[a b].include?(k) }
p hsh.select
p second_arr
p second_hsh
