require_relative './binary-search-tree'

tree = Tree.new((Array.new(15) { rand(1..100) }))

tree.pretty_print
print "\nBalanced: #{tree.balanced?}\n\n"

p tree.levelorder
p tree.preorder
p tree.postorder
p tree.inorder

(Array.new(5) { rand(100..150) }).map {|n| tree.insert(n)}

tree.pretty_print
print "\nBalanced: #{tree.balanced?}\n\n"

tree.rebalance

tree.pretty_print
print "\nBalanced: #{tree.balanced?}\n\n"

p tree.levelorder
p tree.preorder
p tree.postorder
p tree.inorder