def most_common_bit(bits)
  common_bit = 0
  bits.each do |bit|
    if bit == '1'
      common_bit += 1
    else
      common_bit -= 1
    end
  end

  common_bit >= 0 ? '1' : '0'
end

def least_common_bit(bits)
  most_common_bit(bits) == '1' ? '0' : '1'
end

def power_consumption(diagnostic_numbers)
  gamma_rate = ''
  epsilon_rate = ''

  bits_by_position = diagnostic_numbers[0].zip(*diagnostic_numbers[1..-1])
  bits_by_position.each do |bits|
    if most_common_bit(bits) == '1'
      gamma_rate += '1'
      epsilon_rate += '0'
    else
      gamma_rate += '0'
      epsilon_rate += '1'
    end
  end

  gamma_rate.to_i(2) * epsilon_rate.to_i(2)
end

def find_rating(diagnostic_numbers)
  position = 0
  loop do
    break if diagnostic_numbers.length == 1

    bits_at_position = diagnostic_numbers.map { |bits| bits[position] }
    common_bit = yield(bits_at_position)
    diagnostic_numbers.select! { |bits| bits[position] == common_bit }
    position += 1
  end

  diagnostic_numbers.first.to_i(2)
end

def life_support_rating(diagnostic_numbers)
  oxygen_generator_rating = find_rating(diagnostic_numbers.dup) do |bits|
    most_common_bit(bits)
  end

  co2_scrubber_rating = find_rating(diagnostic_numbers.dup) do |bits|
    least_common_bit(bits)
  end

  oxygen_generator_rating * co2_scrubber_rating
end

diagnostic_numbers = File.open("input.txt").readlines.map(&:chomp)

puts power_consumption(diagnostic_numbers.map(&:chars))
puts life_support_rating(diagnostic_numbers)
