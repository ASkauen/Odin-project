def fibs(n)
  arr = [0, 1]
  (n - 1).times {arr.push(arr[-2] + arr[-1])}
  arr
end

def fib_rec(n)
  return [0] if n == 0
  return [0, 1] if n == 1
  arr = fib_rec(n - 1)
  arr.push << arr[-1] + arr[-2]
end


print fib_rec(5)