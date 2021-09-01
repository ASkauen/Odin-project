def substrings(str, arr)
    arr.reduce(Hash.new(0)) do |result, substr|
        occurences = str.downcase.scan(substr).count
        result[substr] += occurences unless occurences == 0
        result
    end
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]

substrings("Howdy partner, sit down! How's it going?", dictionary)