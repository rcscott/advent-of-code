grid = File.open("input.txt").readlines.map(&:chomp).map(&:chars)

antennas = Hash.new { |h, k| h[k] = [] }
grid.each_with_index do |row, y|
  row.each_with_index do |antenna, x|
    next if antenna == "."
    antennas[antenna] << {x:, y:}
  end
end

grid_max_x = grid.first.size - 1
grid_max_y = grid.size - 1

def valid_antinode?(antinode, max_x, max_y)
  antinode[:x] >= 0 && antinode[:x] <= max_x && antinode[:y] >= 0 && antinode[:y] <= max_y
end

puts "Part 1:"

valid_antinodes = Set.new
antennas.each do |antenna, antenna_locations|
  antenna_locations.combination(2) do |location1, location2|
    x_diff = location2[:x] - location1[:x]
    y_diff = location2[:y] - location1[:y]

    [
      {x: location1[:x] - x_diff, y: location1[:y] - y_diff},
      {x: location2[:x] + x_diff, y: location2[:y] + y_diff},
    ].each do |antinode|
      valid_antinodes << antinode if valid_antinode?(antinode, grid_max_x, grid_max_y)
    end
  end
end

puts valid_antinodes.count

puts "Part 2:"

valid_antinodes = Set.new
antennas.each do |antenna, antenna_locations|
  antenna_locations.combination(2) do |location1, location2|
    x_diff = location2[:x] - location1[:x]
    y_diff = location2[:y] - location1[:y]

    antinode = location2
    while valid_antinode?(antinode, grid_max_x, grid_max_y)
      valid_antinodes << antinode
      antinode = {x: antinode[:x] - x_diff, y: antinode[:y] - y_diff}
    end

    antinode = location1
    while valid_antinode?(antinode, grid_max_x, grid_max_y)
      valid_antinodes << antinode
      antinode = {x: antinode[:x] + x_diff, y: antinode[:y] + y_diff}
    end
  end
end

puts valid_antinodes.count
