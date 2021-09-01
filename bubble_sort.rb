def bubble_sort(arr)
    arr.each_index do |i|
        return arr unless arr[i + 1]
        if arr[i] > arr[i + 1]
            arr.insert(i + 2, arr[i])
            arr.delete_at(i)
            bubble_sort(arr)
        end
    end
end

p bubble_sort([23, 12, 1234, 12, 23, 22, 1235, 41, 124, 55, 2, 4, 1223, 12, 46, 1])