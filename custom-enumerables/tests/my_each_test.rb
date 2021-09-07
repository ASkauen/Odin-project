# frozen_string_literal: true

require '../enum_methods'

a = %w[a b c]
b = { a: 1, b: 2, c: 3 }
puts '==: my_each'
a.my_each { |el| puts el }
b.my_each { |k, v| puts "#{k} => #{v}" }
p a.my_each
puts '==: each'
a.each { |el| puts el }
b.each { |k, v| puts "#{k} => #{v}" }
p a.each
