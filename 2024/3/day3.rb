input = File.open("input.txt").read
pattern = /mul\((\d{1,3}),(\d{1,3})\)/

puts "Part 1:"

tally = input.scan(pattern).sum do |x, y|
  x.to_i * y.to_i
end

puts tally

puts "Part 2:"

tally = input.split("do()").sum do |chunk|
  chunk.split("don't()").first.scan(pattern).sum do |x, y|
    x.to_i * y.to_i
  end
end

puts tally
