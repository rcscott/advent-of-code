input = File.open("input.txt").readlines.map(&:chomp)

def evaluate_possibilities(test_value, nums, allow_concat: false)
  num1, num2, *remaining_nums = nums

  combinations = [num1 + num2, num1 * num2]
  if allow_concat
    combinations << (num1.to_s + num2.to_s).to_i
  end

  if remaining_nums.empty?
    return combinations.any? { |result| result == test_value }
  end

  combinations.map do |new_num|
    evaluate_possibilities(test_value, [new_num] + remaining_nums, allow_concat:)
  end.flatten.any?
end

puts "Part 1:"

tally = input.sum do |row|
  test_value, nums = row.split(": ")
  test_value = test_value.to_i
  nums = nums.split(" ").map(&:to_i)

  evaluate_possibilities(test_value, nums) ? test_value : 0
end

puts tally

puts "Part 2:"

tally = input.sum do |row|
  test_value, nums = row.split(": ")
  test_value = test_value.to_i
  nums = nums.split(" ").map(&:to_i)

  evaluate_possibilities(test_value, nums, allow_concat: true) ? test_value : 0
end

puts tally
