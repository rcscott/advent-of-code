def decode_output_values(signal_patterns, output_values)
  signal_patterns.map! { |p| p.chars.sort }

  one = signal_patterns.select { |p| p.length == 2 }.first
  four = signal_patterns.select { |p| p.length == 4 }.first
  seven = signal_patterns.select { |p| p.length == 3 }.first
  eight = signal_patterns.select { |p| p.length == 7 }.first

  size_5_patterns = signal_patterns.select { |p| p.length == 5 }
  size_6_patterns = signal_patterns.select { |p| p.length == 6 }

  a = (seven - one)
  g = size_5_patterns.reduce(:&) - a - four
  d = size_5_patterns.reduce(:&) - a - g
  f = (size_6_patterns.reduce(:&) - a - g) & one
  c = one - f
  b = four - d - c - f
  e = eight - a - b - c - d - f - g

  decoder = {
    (a + b + c + e + f + g).sort.join => 0,
    (c + f).sort.join =>  1,
    (a + c + d + e + g).sort.join =>  2,
    (a + c + d + f + g).sort.join =>  3,
    (b + c + d + f).sort.join =>  4,
    (a + b + d + f + g).sort.join =>  5,
    (a + b + d + e + f + g).sort.join =>  6,
    (a + c + f).sort.join =>  7,
    (a + b + c + d + e + f + g).sort.join =>  8,
    (a + b + c + d + f + g).sort.join =>  9
  }

  output_values.map! do |value|
    decoder[value.chars.sort.join]
  end

  output_values.join.to_i
end

data = File.open('input.txt').readlines.map(&:chomp)

entries = data.map do |line|
  signal_patterns, output_values = line.split(' | ')
  {signal_patterns: signal_patterns.split, output_values: output_values.split}
end

count = entries.inject(0) do |sum, entry|
  sum + entry[:output_values].count do |value|
    [2, 3, 4, 7].include? value.length
  end
end

puts count

count = entries.inject(0) do |sum, entry|
  sum + decode_output_values(entry[:signal_patterns], entry[:output_values])
end

puts count
