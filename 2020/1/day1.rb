numbers = File.open("day1_input.txt").readlines.map(&:chomp).map(&:to_i)

# Part 1 - two numbers adding up to 2020
puts "### Part 1: ###"
found = false

numbers.each_index do |i|
  numbers.each_index do |j|
    next if i == j

    if numbers[i] + numbers[j] == 2020
      puts numbers[i], numbers[j], numbers[i] * numbers[j]
      found = true
      break
    end
  end

  break if found
end

# Part 2 - three numbers adding up to 2020
puts "\n### Part 2: ###"
found = false

numbers.each_index do |i|
  numbers.each_index do |j|
    numbers.each_index do |k|
      next if i == j || j == k

      if numbers[i] + numbers[j] + numbers[k] == 2020
        puts numbers[i], numbers[j], numbers[k], numbers[i] * numbers[j] * numbers[k]
        found = true
        break
      end
    end

    break if found
  end

  break if found
end
