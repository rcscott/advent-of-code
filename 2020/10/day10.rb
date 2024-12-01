filename = "day10_input.txt"
joltage_adapters = File.open(filename).readlines.map(&:chomp).map(&:to_i).sort

joltage_differences = Hash.new(0)

joltage_adapters.each_index do |i|
  if i == 0
    joltage_differences[joltage_adapters[i]] += 1
  else
    diff = joltage_adapters[i] - joltage_adapters[i - 1]
    joltage_differences[diff] += 1
  end
end

joltage_differences[3] += 1
puts joltage_differences

puts joltage_differences[1] * joltage_differences[3]

def is_valid_first_joltage(joltage)
  joltage <= 3
end

def is_valid_last_joltage(joltage, max_joltage)
  max_joltage == joltage + 3
end

def is_valid_next_joltage(joltage, next_joltage)
  next_joltage - joltage <= 3 && next_joltage - joltage >= 1
end

def count_valid_arrangements(adapters, position, max_joltage, solved_counts)
  if is_valid_last_joltage(adapters[position], max_joltage)
    return 1
  end

  next_valid_positions = (position + 1..adapters.length - 1).select do |next_position|
    is_valid_next_joltage(adapters[position], adapters[next_position])
  end

  return next_valid_positions.sum(0) do |next_position|
    if solved_counts.has_key?(next_position)
      solved_counts[next_position]
    else
      puts "calculating #{adapters[next_position]}"
      solved_counts[next_position] = count_valid_arrangements(adapters, next_position, max_joltage, solved_counts)
    end
  end
end

max_joltage = joltage_adapters.last + 3
valid_adapter_arrangements = 0
# solved counts holds already computed results: {position: count}
solved_counts = {}

joltage_adapters.each_index do |i|
  if is_valid_first_joltage(joltage_adapters[i])
    valid_adapter_arrangements += count_valid_arrangements(joltage_adapters, i, max_joltage, solved_counts)
  end
end

puts "Valid arrangements: #{valid_adapter_arrangements}"
