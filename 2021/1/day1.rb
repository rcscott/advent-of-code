measurements = File.open("input.txt").readlines.map(&:chomp).map(&:to_i)

# Part 1 - count number of increases
puts "### Part 1: ###"
increases_count = 0
previous_measurement = nil

measurements.each do |measurement|
  if !previous_measurement.nil? && measurement > previous_measurement
    increases_count += 1
  end

  previous_measurement = measurement
end

puts increases_count

# Part 2 - count number of increases across sliding three-measurement window
puts "\n### Part 2: initial brute force###"
increases_count = 0
previous_measurement_sum = nil

measurements.each_with_index do |measurement, index|
  next unless index >= 2

  measurement_sum = measurements[index - 2..index].inject(:+)
  if !previous_measurement_sum.nil? && measurement_sum > previous_measurement_sum
    increases_count += 1
  end

  previous_measurement_sum = measurement_sum
end

puts increases_count

# Part 2 - better performance
puts "\n### Part 2: recursive ###"

def calculate_increases(a, b, c, remaining)
  return 0 if remaining.empty?

  d = remaining.shift
  increase = a + b + c < b + c + d ? 1 : 0

  return increase + calculate_increases(b, c, d, remaining)
end

increases_count = calculate_increases(
  measurements.shift,
  measurements.shift,
  measurements.shift,
  measurements
)

puts increases_count
