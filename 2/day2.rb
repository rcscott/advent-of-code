# "forward 5\ndown3" => [["forward", 5], ["down", 3]]
commands = File.open("input.txt").readlines.map do |command|
  direction, value = command.chomp.split
  [direction, value.to_i]
end

# Part 1: calculate position and depth at end of commands list
puts "### Part 1: ###"
position = 0
depth = 0

commands.each do |direction, value|
  case direction
  when "forward"
    position += value
  when "down"
    depth += value
  when "up"
    depth -= value
  end
end

puts position * depth

# Part 2: calculate position and depth at end of commands list using aim
puts "### Part 2: ###"
position = 0
depth = 0
aim = 0

commands.each do |direction, value|
  case direction
  when "forward"
    position += value
    depth += aim * value
  when "down"
    aim += value
  when "up"
    aim -= value
  end
end

puts position * depth
