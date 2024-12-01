filename = "day9_input.txt"
lines = File.open(filename).readlines.map(&:chomp).map(&:to_i)

def find_invalid_number(numbers)
  preamble_length = 25

  previous_numbers = numbers.shift(preamble_length)

  while numbers.length > 0 do
    current_number = numbers.shift

    match_found = false
    previous_numbers.each do |n1|
      previous_numbers.each do |n2|
        if n1 != n2 && n1 + n2 == current_number
          match_found = true
          break
        end
      end

      break if match_found
    end

    if !match_found
      puts "Number #{current_number} is not valid"
      return current_number
    end

    previous_numbers << current_number
    previous_numbers.shift
  end
end

def get_contiguous_sum_set(numbers, invalid_number)
  numbers.each_index do |i|
    sum = numbers[i]
    j = i
    while sum < invalid_number
      j += 1
      break if numbers[j].nil?

      sum += numbers[j]
    end

    if sum == invalid_number
      return numbers[i..j]
    end
  end
end

invalid_number = find_invalid_number(lines.clone)
solution = get_contiguous_sum_set(lines, invalid_number).minmax.sum

puts "Sum of the min and max from a contiguous set that add to the invalid number: #{solution}"
