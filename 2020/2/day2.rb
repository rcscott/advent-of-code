password_data = File.open("day2_input.txt").readlines.map(&:chomp).map do |line|
  line.match /(?<position1>\d+)-(?<position2>\d+) (?<letter>[a-z]): (?<password>[a-z]+)/
end

# Part 1
puts "### Part 1: ###"
valid_password_count = 0

password_data.each do |password|
  char_count = password[:password].chars.count(password[:letter])
  if char_count >= password[:position1].to_i && char_count <= password[:position2].to_i
    valid_password_count += 1
  end
end

puts "Valid password count: #{valid_password_count}"

# Part 2
puts "\n### Part 2: ###"
valid_password_count = 0

password_data.each do |password|
  position1 = password[:position1].to_i - 1
  position2 = password[:position2].to_i - 1

  if (password[:password][position1] == password[:letter]) ^ (password[:password][position2] == password[:letter])
    valid_password_count += 1
  end
end

puts "Valid password count: #{valid_password_count}"
