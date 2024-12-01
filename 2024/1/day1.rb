location_pairs = File.open("input.txt").readlines.map(&:chomp).map(&:split)

left_list = []
right_list = []
location_pairs.each do |left_location, right_location|
  left_list << left_location.to_i
  right_list << right_location.to_i
end

# Part 1
left_list.sort!
right_list.sort!

tally = left_list.zip(right_list).sum do |left_location, right_location|
  (left_location - right_location).abs
end

puts tally

# Part 2
right_location_counts = Hash.new(0)
right_list.each { |location| right_location_counts[location] += 1 }

tally = left_list.sum do |location|
  location * right_location_counts[location]
end

puts tally
