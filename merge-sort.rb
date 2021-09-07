def merge_sort(arr)
  return arr if arr.size < 2

  left_half = merge_sort(arr[0..((arr.size / 2).to_i - 1)])
  right_half = merge_sort(arr[((arr.size / 2).to_i)..-1])
  sorted = []

  until left_half.empty? || right_half.empty?
    left_half.first <= right_half.first ? sorted << left_half.shift : sorted << right_half.shift
  end

  sorted + left_half + right_half
end

print merge_sort([2, 1, 4, 5, 7, 6])
