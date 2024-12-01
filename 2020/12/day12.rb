filename = "day12_input.txt"
nav_instructions = File.open(filename).readlines.map(&:chomp)

# [{action: "F", unit: 10}]
nav_instructions = nav_instructions.map do |instruction|
  {
    action: instruction[0],
    unit: instruction[1..].to_i,
  }
end

nav_functions = {
  "N" => ->(x, y, unit) { [x, y + unit] },
  "S" => ->(x, y, unit) { [x, y - unit] },
  "E" => ->(x, y, unit) { [x + unit, y] },
  "W" => ->(x, y, unit) { [x - unit, y] },
}

ship_x = 0
ship_y = 0
waypoint_x = 10
waypoint_y = 1

nav_instructions.each do |instruction|
  # puts "instruction: #{instruction}, pos_x: #{ship_x}, pos_y: #{ship_y}, waypoint_x: #{waypoint_x}, waypoint_y: #{waypoint_y}"
  if ["N", "S", "E", "W"].include?(instruction[:action])
    waypoint_x, waypoint_y = nav_functions[instruction[:action]].call(waypoint_x, waypoint_y, instruction[:unit])
  elsif instruction[:action] == "L"
    (instruction[:unit] / 90).times { temp_y = waypoint_x; waypoint_x = -1 * waypoint_y; waypoint_y = temp_y }
  elsif instruction[:action] == "R"
    (instruction[:unit] / 90).times { temp_x = waypoint_y; waypoint_y = -1 * waypoint_x; waypoint_x = temp_x }
  elsif instruction[:action] == "F"
    ship_x += instruction[:unit] * waypoint_x
    ship_y += instruction[:unit] * waypoint_y
  end
end

puts "X: #{ship_x}, Y: #{ship_y}"
puts "Manhattan distance: #{ship_x.abs + ship_y.abs}"
