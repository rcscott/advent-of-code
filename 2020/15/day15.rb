# starting_numbers = "0,3,6"
# starting_numbers = "1,3,2"
# starting_numbers = "2,1,3"
# starting_numbers = "1,2,3"
# starting_numbers = "2,3,1"
# starting_numbers = "3,2,1"
# starting_numbers = "3,1,2"
starting_numbers = "14,8,16,0,1,17"

starting_numbers = starting_numbers.split(',').map(&:to_i)

turn_count = 1
numbers_count = Hash.new { |h, k| h[k] = [] }

starting_numbers.each do |n|
  numbers_count[n] << turn_count
  turn_count += 1
end

prev_number = starting_numbers.last
loop do
  if numbers_count[prev_number].length == 1
    number = 0
  else
    number = numbers_count[prev_number][-1] - numbers_count[prev_number][-2]
  end

  numbers_count[number] << turn_count
  prev_number = number
  break if turn_count == 30000000

  turn_count += 1
end

puts "30000000th number is: #{prev_number}"
